import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bramble_colors.dart';
import '../../../core/theme/bramble_typography.dart';
import '../../../core/widgets/bramble_button.dart';
import '../../auth/presentation/bloc/auth_bloc.dart';

enum _PaymentStage { select, detail, loading, success }

class PaymentScreen extends StatefulWidget {
  final Map<String, dynamic>? pendingPack;

  const PaymentScreen({super.key, this.pendingPack});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  _PaymentStage _stage = _PaymentStage.select;
  String? _method;
  final _cardNumController = TextEditingController();
  final _cardExpController = TextEditingController();
  final _cardCvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumController.dispose();
    _cardExpController.dispose();
    _cardCvvController.dispose();
    super.dispose();
  }

  static const _methods = [
    (id: 'bank', label: 'Bank transfer', note: 'Vietcombank, Techcombank and 40+ banks', glyph: '🏦'),
    (id: 'momo', label: 'MoMo', note: 'Pay with your MoMo wallet', glyph: 'M'),
    (id: 'zalopay', label: 'ZaloPay', note: 'Pay with your ZaloPay wallet', glyph: 'Z'),
    (id: 'card', label: 'Visa / Mastercard', note: 'International or domestic card', glyph: '¤'),
  ];

  Color _glyphBg(String id) => switch (id) {
        'bank' => BrambleColors.lightSage,
        'momo' => BrambleColors.peachSelection,
        'zalopay' => const Color(0xFFCFE3FF),
        _ => BrambleColors.creamDivider,
      };

  Color _glyphFg(String id) => switch (id) {
        'bank' => BrambleColors.deepGreen,
        'momo' => const Color(0xFFA91D5C),
        'zalopay' => const Color(0xFF1A4FA0),
        _ => const Color(0xFF474238),
      };

  void _confirmSuccess() {
    setState(() => _stage = _PaymentStage.loading);
    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      final pack = widget.pendingPack;
      if (pack != null) {
        final coins = int.tryParse(pack['coins'].toString()) ?? 0;
        context.read<AuthBloc>().add(AuthAddCoinsRequested(coins));
      }
      setState(() => _stage = _PaymentStage.success);
    });
  }

  @override
  Widget build(BuildContext context) {
    final pack = widget.pendingPack;

    return Scaffold(
      backgroundColor: BrambleColors.creamBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: BrambleColors.creamInk.withOpacity(0.06),
                    ),
                    child: const Icon(Icons.chevron_left_rounded, color: BrambleColors.creamInk, size: 28),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 14, 22, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payment method',
                      style: BrambleTypography.displaySmall(color: BrambleColors.creamInk)
                          .copyWith(fontSize: 28),
                    ),
                    if (pack != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        '${pack['coins']} coins · ${pack['price']}',
                        style: BrambleTypography.bodyMedium(color: BrambleColors.creamSubdued),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 6),
              if (_stage == _PaymentStage.select) _buildSelectStage(),
              if (_stage == _PaymentStage.detail) _buildDetailStage(pack),
              if (_stage == _PaymentStage.loading) _buildLoadingStage(),
              if (_stage == _PaymentStage.success) _buildSuccessStage(pack),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectStage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
      child: Column(
        children: [
          Column(
            children: _methods.map((m) {
              final isSelected = _method == m.id;
              return Padding(
                padding: const EdgeInsets.only(bottom: 11),
                child: GestureDetector(
                  onTap: () => setState(() => _method = m.id),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    decoration: BoxDecoration(
                      color: isSelected ? BrambleColors.peachSelection : BrambleColors.creamSurface,
                      borderRadius: BorderRadius.circular(22),
                      border: isSelected
                          ? Border.all(color: BrambleColors.primaryOrange, width: 2)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: _glyphBg(m.id),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              m.glyph,
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w800,
                                color: _glyphFg(m.id),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.label,
                                style: BrambleTypography.bodyLarge(
                                  color: BrambleColors.creamInk,
                                  fontWeight: FontWeight.w700,
                                ).copyWith(fontSize: 15),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                m.note,
                                style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)
                                    .copyWith(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          BrambleButton(
            text: 'Continue',
            onPressed: _method != null ? () => setState(() => _stage = _PaymentStage.detail) : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailStage(Map<String, dynamic>? pack) {
    final price = pack?['price']?.toString() ?? '';
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
      child: Column(
        children: [
          if (_method == 'bank') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BrambleColors.creamSurface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: BrambleColors.creamDivider,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          'QR code',
                          style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)
                              .copyWith(fontWeight: FontWeight.w600, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text('Bank', style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)),
                  const SizedBox(height: 4),
                  Text(
                    'Vietcombank · 0123 4567 890',
                    style: BrambleTypography.bodyLarge(
                      color: BrambleColors.creamInk,
                      fontWeight: FontWeight.w700,
                    ).copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 10),
                  Text('Transfer content', style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)),
                  const SizedBox(height: 4),
                  Text(
                    'BRAMBLE ${pack?['coins'] ?? ''}',
                    style: BrambleTypography.bodyLarge(
                      color: BrambleColors.creamInk,
                      fontWeight: FontWeight.w700,
                    ).copyWith(fontSize: 15, fontFamily: 'monospace'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BrambleButton(text: "I've completed the transfer", onPressed: _confirmSuccess),
          ] else if (_method == 'momo' || _method == 'zalopay') ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: BrambleColors.creamSurface,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: _glyphBg(_method!),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        _method == 'momo' ? 'M' : 'Z',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: _glyphFg(_method!)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Approve in ${_method == 'momo' ? 'MoMo' : 'ZaloPay'}',
                    style: BrambleTypography.bodyLarge(
                      color: BrambleColors.creamInk,
                      fontWeight: FontWeight.w700,
                    ).copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'We sent a payment request to your ${_method == 'momo' ? 'MoMo' : 'ZaloPay'} app'
                    '${price.isNotEmpty ? ' for $price' : ''}. Approve it there to continue.',
                    textAlign: TextAlign.center,
                    style: BrambleTypography.bodySmall(color: BrambleColors.creamMuted)
                        .copyWith(fontSize: 13, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            BrambleButton(text: "I've approved in the app", onPressed: _confirmSuccess),
          ] else ...[
            _cardField('CARD NUMBER', _cardNumController, '4242 4242 4242 4242'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _cardField('EXPIRY', _cardExpController, 'MM/YY')),
                const SizedBox(width: 10),
                Expanded(child: _cardField('CVV', _cardCvvController, '123')),
              ],
            ),
            const SizedBox(height: 16),
            BrambleButton(
              text: price.isNotEmpty ? 'Pay $price' : 'Pay',
              onPressed: _confirmSuccess,
            ),
          ],
        ],
      ),
    );
  }

  Widget _cardField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: BrambleTypography.labelUppercase(color: BrambleColors.creamMuted)),
        const SizedBox(height: 7),
        Container(
          height: 54,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: BrambleColors.creamSurface,
            borderRadius: BorderRadius.circular(999),
          ),
          child: TextField(
            controller: controller,
            style: BrambleTypography.bodyLarge(color: BrambleColors.creamInk, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: BrambleTypography.bodyLarge(color: BrambleColors.creamMuted),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingStage() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(22, 60, 22, 60),
      child: Column(
        children: [
          SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              valueColor: AlwaysStoppedAnimation<Color>(BrambleColors.primaryOrange),
            ),
          ),
          SizedBox(height: 16),
          Text('Processing payment…'),
        ],
      ),
    );
  }

  Widget _buildSuccessStage(Map<String, dynamic>? pack) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: BrambleColors.lightSage,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              pack != null
                  ? 'Payment confirmed. Coins have been added to your balance.'
                  : 'Payment method saved.',
              style: BrambleTypography.bodyMedium(
                color: BrambleColors.deepGreen,
                fontWeight: FontWeight.w600,
              ).copyWith(fontSize: 14.5),
            ),
          ),
          const SizedBox(height: 18),
          BrambleButton(
            text: 'Back to reading',
            variant: BrambleButtonVariant.dark,
            onPressed: () => context.pop(),
          ),
        ],
      ),
    );
  }
}
