package com.bramble.novel.service;

import com.bramble.novel.dto.auth.AuthResponse;
import com.bramble.novel.dto.auth.LoginRequest;
import com.bramble.novel.dto.auth.RegisterRequest;
import com.bramble.novel.dto.auth.UserResponse;
import com.bramble.novel.entity.Role;
import com.bramble.novel.entity.User;
import com.bramble.novel.entity.UserPreferences;
import com.bramble.novel.exception.ConflictException;
import com.bramble.novel.exception.UnauthorizedException;
import com.bramble.novel.mapper.UserMapper;
import com.bramble.novel.repository.RefreshTokenRepository;
import com.bramble.novel.repository.UserPreferencesRepository;
import com.bramble.novel.repository.UserRepository;
import com.bramble.novel.security.JwtTokenProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private UserPreferencesRepository preferencesRepository;

    @Mock
    private RefreshTokenRepository refreshTokenRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtTokenProvider tokenProvider;

    @Mock
    private UserMapper userMapper;

    @InjectMocks
    private AuthService authService;

    private User sampleUser;

    @BeforeEach
    void setUp() {
        sampleUser = User.builder()
                .id("u-123")
                .email("test@bramble.com")
                .passwordHash("hashedPass")
                .displayName("Test User")
                .role(Role.USER)
                .coins(100)
                .isVip(false)
                .build();
    }

    @Test
    void register_Success() {
        RegisterRequest request = RegisterRequest.builder()
                .email("test@bramble.com")
                .password("password123")
                .displayName("Test User")
                .build();

        when(userRepository.existsByEmail("test@bramble.com")).thenReturn(false);
        when(passwordEncoder.encode("password123")).thenReturn("hashedPass");
        when(userRepository.save(any(User.class))).thenReturn(sampleUser);
        when(preferencesRepository.save(any(UserPreferences.class))).thenReturn(new UserPreferences());
        when(tokenProvider.generateTokenFromUserId(anyString(), anyString(), anyString())).thenReturn("access-token");
        when(tokenProvider.getExpirationInMs()).thenReturn(86400000L);
        when(tokenProvider.getRefreshExpirationInMs()).thenReturn(604800000L);
        when(userMapper.toUserResponse(any(User.class))).thenReturn(UserResponse.builder().id("u-123").email("test@bramble.com").build());

        AuthResponse response = authService.register(request);

        assertNotNull(response);
        assertEquals("access-token", response.getAccessToken());
        assertNotNull(response.getRefreshToken());
        verify(userRepository, times(1)).save(any(User.class));
    }

    @Test
    void register_DuplicateEmail_ThrowsConflict() {
        RegisterRequest request = RegisterRequest.builder()
                .email("test@bramble.com")
                .password("password123")
                .build();

        when(userRepository.existsByEmail("test@bramble.com")).thenReturn(true);

        assertThrows(ConflictException.class, () -> authService.register(request));
    }

    @Test
    void login_Success() {
        LoginRequest request = LoginRequest.builder()
                .email("test@bramble.com")
                .password("password123")
                .build();

        when(userRepository.findByEmail("test@bramble.com")).thenReturn(Optional.of(sampleUser));
        when(passwordEncoder.matches("password123", "hashedPass")).thenReturn(true);
        when(tokenProvider.generateTokenFromUserId(anyString(), anyString(), anyString())).thenReturn("access-token");
        when(tokenProvider.getExpirationInMs()).thenReturn(86400000L);
        when(tokenProvider.getRefreshExpirationInMs()).thenReturn(604800000L);
        when(userMapper.toUserResponse(any(User.class))).thenReturn(UserResponse.builder().id("u-123").email("test@bramble.com").build());

        AuthResponse response = authService.login(request);

        assertNotNull(response);
        assertEquals("access-token", response.getAccessToken());
    }

    @Test
    void login_WrongPassword_ThrowsUnauthorized() {
        LoginRequest request = LoginRequest.builder()
                .email("test@bramble.com")
                .password("wrongpassword")
                .build();

        when(userRepository.findByEmail("test@bramble.com")).thenReturn(Optional.of(sampleUser));
        when(passwordEncoder.matches("wrongpassword", "hashedPass")).thenReturn(false);

        assertThrows(UnauthorizedException.class, () -> authService.login(request));
    }
}
