package com.bramble.novel.service;

import com.bramble.novel.dto.auth.*;
import com.bramble.novel.entity.RefreshToken;
import com.bramble.novel.entity.Role;
import com.bramble.novel.entity.User;
import com.bramble.novel.entity.UserPreferences;
import com.bramble.novel.exception.BadRequestException;
import com.bramble.novel.exception.ConflictException;
import com.bramble.novel.exception.ResourceNotFoundException;
import com.bramble.novel.exception.UnauthorizedException;
import com.bramble.novel.mapper.UserMapper;
import com.bramble.novel.repository.RefreshTokenRepository;
import com.bramble.novel.repository.UserPreferencesRepository;
import com.bramble.novel.repository.UserRepository;
import com.bramble.novel.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Instant;
import java.util.UUID;

@Slf4j
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserRepository userRepository;
    private final UserPreferencesRepository preferencesRepository;
    private final RefreshTokenRepository refreshTokenRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider tokenProvider;
    private final UserMapper userMapper;

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        if (userRepository.existsByEmail(request.getEmail())) {
            throw new ConflictException("Email is already registered");
        }

        User user = User.builder()
                .email(request.getEmail())
                .passwordHash(passwordEncoder.encode(request.getPassword()))
                .displayName(request.getDisplayName() != null ? request.getDisplayName() : request.getEmail().split("@")[0])
                .role(Role.USER)
                .coins(100) // Welcome bonus coins
                .isVip(false)
                .build();

        user = userRepository.save(user);

        // Default preferences
        UserPreferences preferences = UserPreferences.builder()
                .user(user)
                .theme("CREAM")
                .fontSize(18)
                .fontFamily("Serif")
                .lineHeight(1.6)
                .marginHorizontal(24.0)
                .autoUnlock(false)
                .soundEffects(true)
                .build();
        preferencesRepository.save(preferences);
        user.setPreferences(preferences);

        String accessToken = tokenProvider.generateTokenFromUserId(user.getId(), user.getEmail(), "ROLE_" + user.getRole().name());
        String refreshToken = createRefreshToken(user);

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(tokenProvider.getExpirationInMs() / 1000)
                .user(userMapper.toUserResponse(user))
                .build();
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new UnauthorizedException("Invalid email or password"));

        if (!passwordEncoder.matches(request.getPassword(), user.getPasswordHash())) {
            throw new UnauthorizedException("Invalid email or password");
        }

        String accessToken = tokenProvider.generateTokenFromUserId(user.getId(), user.getEmail(), "ROLE_" + user.getRole().name());
        String refreshToken = createRefreshToken(user);

        return AuthResponse.builder()
                .accessToken(accessToken)
                .refreshToken(refreshToken)
                .tokenType("Bearer")
                .expiresIn(tokenProvider.getExpirationInMs() / 1000)
                .user(userMapper.toUserResponse(user))
                .build();
    }

    @Transactional
    public AuthResponse refreshToken(RefreshTokenRequest request) {
        RefreshToken token = refreshTokenRepository.findByToken(request.getRefreshToken())
                .orElseThrow(() -> new UnauthorizedException("Invalid refresh token"));

        if (token.getRevoked() || token.getExpiresAt().isBefore(Instant.now())) {
            refreshTokenRepository.delete(token);
            throw new UnauthorizedException("Refresh token is expired or revoked");
        }

        User user = token.getUser();
        String newAccessToken = tokenProvider.generateTokenFromUserId(user.getId(), user.getEmail(), "ROLE_" + user.getRole().name());
        String newRefreshToken = createRefreshToken(user);

        // Revoke old token
        token.setRevoked(true);
        refreshTokenRepository.save(token);

        return AuthResponse.builder()
                .accessToken(newAccessToken)
                .refreshToken(newRefreshToken)
                .tokenType("Bearer")
                .expiresIn(tokenProvider.getExpirationInMs() / 1000)
                .user(userMapper.toUserResponse(user))
                .build();
    }

    @Transactional
    public void logout(String userId, String refreshToken) {
        if (refreshToken != null) {
            refreshTokenRepository.findByToken(refreshToken).ifPresent(token -> {
                token.setRevoked(true);
                refreshTokenRepository.save(token);
            });
        }
    }

    @Transactional(readOnly = true)
    public UserResponse getCurrentUser(String userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));
        return userMapper.toUserResponse(user);
    }

    @Transactional
    public UserResponse updatePreferences(String userId, UserPreferencesDto dto) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User", "id", userId));

        UserPreferences pref = user.getPreferences();
        if (pref == null) {
            pref = UserPreferences.builder().user(user).build();
        }

        if (dto.getTheme() != null) pref.setTheme(dto.getTheme());
        if (dto.getFontSize() != null) pref.setFontSize(dto.getFontSize());
        if (dto.getFontFamily() != null) pref.setFontFamily(dto.getFontFamily());
        if (dto.getLineHeight() != null) pref.setLineHeight(dto.getLineHeight());
        if (dto.getMarginHorizontal() != null) pref.setMarginHorizontal(dto.getMarginHorizontal());
        if (dto.getAutoUnlock() != null) pref.setAutoUnlock(dto.getAutoUnlock());
        if (dto.getSoundEffects() != null) pref.setSoundEffects(dto.getSoundEffects());

        preferencesRepository.save(pref);
        user.setPreferences(pref);

        return userMapper.toUserResponse(user);
    }

    private String createRefreshToken(User user) {
        String tokenString = UUID.randomUUID().toString();
        RefreshToken refreshToken = RefreshToken.builder()
                .token(tokenString)
                .user(user)
                .expiresAt(Instant.now().plusMillis(tokenProvider.getRefreshExpirationInMs()))
                .revoked(false)
                .build();
        refreshTokenRepository.save(refreshToken);
        return tokenString;
    }
}
