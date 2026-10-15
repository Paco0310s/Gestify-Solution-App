import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gestify_solution/business/features/businesses/businesses_provider.dart';
import 'package:gestify_solution/business/features/businesses/models/business_model.dart';
import 'package:gestify_solution/business/features/businesses/models/businesses_type_model.dart';
import 'package:gestify_solution/business/features/businesses/models/create_business_dto.dart';
import 'package:gestify_solution/business/features/businesses/models/industries_model.dart';
import 'package:gestify_solution/business/features/businesses/models/types_regimens_taxes_model.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu_provider.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/utils/snackbar_util.dart';
import 'package:gestify_solution/common/utils/validators.dart';
import 'package:gestify_solution/common/widgets/app_button.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_layout.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/app_text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class BusinessAddScreen extends StatelessWidget {
  final String title;
  final BusinessModel? initialBusiness;

  const BusinessAddScreen({
    super.key,
    required this.title,
    this.initialBusiness,
  });

  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as BusinessModel?;
    final effectiveBusiness = initialBusiness ?? routeArgs;
    final effectiveTitle = effectiveBusiness != null ? AppTexts.editBusinessTitle : title;

    return AppDashboardLayout(
      title: effectiveTitle,
      mobileChild: BusinessAddMobileView(initialBusiness: effectiveBusiness),
      tabletChild: BusinessAddTabletView(initialBusiness: effectiveBusiness),
      desktopChild: BusinessAddDesktopView(initialBusiness: effectiveBusiness),
    );
  }
}

class BusinessAddDesktopView extends StatelessWidget {
  final BusinessModel? initialBusiness;

  const BusinessAddDesktopView({super.key, this.initialBusiness});

  @override
  Widget build(BuildContext context) {
    return BusinessAddFormContent(isDesktop: true, initialBusiness: initialBusiness);
  }
}

class BusinessAddTabletView extends StatelessWidget {
  final BusinessModel? initialBusiness;

  const BusinessAddTabletView({super.key, this.initialBusiness});

  @override
  Widget build(BuildContext context) {
    return BusinessAddFormContent(isTablet: true, initialBusiness: initialBusiness);
  }
}

class BusinessAddMobileView extends StatelessWidget {
  final BusinessModel? initialBusiness;

  const BusinessAddMobileView({super.key, this.initialBusiness});

  @override
  Widget build(BuildContext context) {
    return BusinessAddFormContent(isMobile: true, initialBusiness: initialBusiness);
  }
}

class BusinessAddFormContent extends ConsumerStatefulWidget {
  final bool isDesktop;
  final bool isTablet;
  final bool isMobile;
  final BusinessModel? initialBusiness;

  const BusinessAddFormContent({
    super.key,
    this.isDesktop = false,
    this.isTablet = false,
    this.isMobile = false,
    this.initialBusiness,
  });

  @override
  ConsumerState<BusinessAddFormContent> createState() => _BusinessAddFormContentState();
}

class _BusinessAddFormContentState extends ConsumerState<BusinessAddFormContent> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _rfcController = TextEditingController();
  final _establishmentDateController = TextEditingController();

  IndustriesModel? _selectedIndustry;
  BusinessesTypeModel? _selectedBusinessType;
  TypesRegimensTaxesModel? _selectedTaxRegimen;

  XFile? _logoFile;
  Uint8List? _logoBytes;

  XFile? _coverFile;
  Uint8List? _coverBytes;

  final ImagePicker _picker = ImagePicker();
  static const int maxFileSizeBytes = 2 * 1024 * 1024; // 2MB

  bool get isEditing => widget.initialBusiness != null;

  @override
  void initState() {
    super.initState();

    if (isEditing) {
      final b = widget.initialBusiness!;
      _nameController.text = b.name;
      _descriptionController.text = b.description;
      _rfcController.text = b.rfc;
      _establishmentDateController.text = b.establishmentDate ?? '';

      if (b.industry != null) {
        try {
          _selectedIndustry = IndustriesModel.defaultIndustries.firstWhere(
            (item) => item.id == b.industry!.id || item.industry.trim().toLowerCase() == b.industry!.industry.trim().toLowerCase(),
          );
        } catch (_) {
          _selectedIndustry = b.industry;
        }
      }

      if (b.businessesType != null) {
        try {
          _selectedBusinessType = BusinessesTypeModel.defaultBusinessTypes.firstWhere(
            (item) => item.id == b.businessesType!.id || item.code.trim().toLowerCase() == b.businessesType!.code.trim().toLowerCase(),
          );
        } catch (_) {
          _selectedBusinessType = b.businessesType;
        }
      }

      if (b.taxRegimen != null) {
        try {
          _selectedTaxRegimen = TypesRegimensTaxesModel.defaultTaxRegimens.firstWhere(
            (item) => item.id == b.taxRegimen!.id || item.regimen.trim().toLowerCase() == b.taxRegimen!.regimen.trim().toLowerCase(),
          );
        } catch (_) {
          _selectedTaxRegimen = b.taxRegimen;
        }
      }
    }

    _nameController.addListener(() => setState(() {}));
    _descriptionController.addListener(() => setState(() {}));
    _rfcController.addListener(() => setState(() {}));
    _establishmentDateController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _rfcController.dispose();
    _establishmentDateController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > maxFileSizeBytes) {
        if (mounted) {
          SnackbarUtil.showError(context, AppTexts.fileTooLargeError);
        }
        return;
      }

      final decodedImage = await decodeImageFromList(bytes);
      final ratio = decodedImage.width / decodedImage.height;
      if (ratio < 0.90 || ratio > 1.10) {
        if (mounted) {
          SnackbarUtil.showError(context, AppTexts.invalidLogoAspectRatioError);
        }
        return;
      }

      setState(() {
        _logoFile = file;
        _logoBytes = bytes;
      });
    } catch (e) {
      if (mounted) {
        SnackbarUtil.showError(context, '${AppTexts.error} $e');
      }
    }
  }

  Future<void> _pickCover() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.lengthInBytes > maxFileSizeBytes) {
        if (mounted) {
          SnackbarUtil.showError(context, AppTexts.fileTooLargeError);
        }
        return;
      }

      final decodedImage = await decodeImageFromList(bytes);
      final ratio = decodedImage.width / decodedImage.height;
      if (ratio < 1.60 || ratio > 1.96) {
        if (mounted) {
          SnackbarUtil.showError(context, AppTexts.invalidCoverAspectRatioError);
        }
        return;
      }

      setState(() {
        _coverFile = file;
        _coverBytes = bytes;
      });
    } catch (e) {
      if (mounted) {
        SnackbarUtil.showError(context, '${AppTexts.error} $e');
      }
    }
  }

  Future<void> _selectEstablishmentDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
      helpText: AppTexts.businessEstablishmentDateLabel,
      cancelText: AppTexts.cancel,
      confirmText: AppTexts.yes,
    );

    if (picked != null) {
      setState(() {
        _establishmentDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedIndustry == null) {
      SnackbarUtil.showError(context, AppTexts.emptyIndustryError);
      return;
    }

    if (_selectedBusinessType == null) {
      SnackbarUtil.showError(context, AppTexts.emptyBusinessTypeError);
      return;
    }

    if (_selectedTaxRegimen == null) {
      SnackbarUtil.showError(context, AppTexts.emptyTaxRegimenError);
      return;
    }

    final dto = CreateBusinessDto(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
      rfc: _rfcController.text.trim().toUpperCase(),
      establishmentDate: _establishmentDateController.text.trim(),
      industryId: _selectedIndustry!.id,
      businessesTypeId: _selectedBusinessType!.id,
      taxRegimenId: _selectedTaxRegimen!.id,
      logo: _logoFile,
      cover: _coverFile,
      logoBytes: _logoBytes,
      coverBytes: _coverBytes,
      logoName: _logoFile?.name,
      coverName: _coverFile?.name,
    );

    if (isEditing) {
      await BusinessActions.update(ref, context, widget.initialBusiness!.id, dto);
    } else {
      await BusinessActions.create(ref, context, dto);
    }
  }

  void _handleCancel() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      ref.read(selectedSideMenuItemProvider.notifier).selectByRoute(Routes.businesses);
      NavigationService.replaceWith(context, Routes.businesses);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(businessAddLoadingProvider);

    if (widget.isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Form Column (Left)
          Expanded(
            flex: 6,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.kWhiteColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.kNeutral200),
              ),
              child: SingleChildScrollView(
                child: _buildForm(isLoading),
              ),
            ),
          ),
          const Gap(24),
          // Preview Column (Right)
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: _buildLivePreview(),
            ),
          ),
        ],
      );
    }

    // Mobile / Tablet view: single column
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildLivePreview(),
          const Gap(20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.kWhiteColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.kNeutral200),
            ),
            child: _buildForm(isLoading),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.kPrimary100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isEditing ? Icons.edit_note_rounded : Icons.add_business_rounded,
                  color: AppColors.kPrimary600,
                  size: 24,
                ),
              ),
              const Gap(12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    isEditing ? AppTexts.editBusinessTitle : AppTexts.addBusinessButton,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.kDark1,
                  ),
                  AppText(
                    isEditing
                        ? AppTexts.editBusinessSubtitle
                        : 'Ingresa los datos fiscales y comerciales de tu nueva empresa',
                    fontSize: 12,
                    color: AppColors.kNeutral500,
                  ),
                ],
              ),
            ],
          ),
          const Gap(24),

          // Business Name
          AppTextField(
            text: AppTexts.businessNameLabel,
            hintText: AppTexts.businessNameHint,
            controller: _nameController,
            textColor: AppColors.kDark2,
            fontWeight: FontWeight.w600,
            validator: ValidatorsUtil.validateBusinessName,
          ),
          const Gap(16),

          // RFC
          AppTextField(
            text: AppTexts.businessRfcLabel,
            hintText: AppTexts.businessRfcHint,
            controller: _rfcController,
            textColor: AppColors.kDark2,
            fontWeight: FontWeight.w600,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9&Ññ]')),
              LengthLimitingTextInputFormatter(13),
              _UpperCaseTextFormatter(),
            ],
            validator: ValidatorsUtil.validateRfc,
          ),
          const Gap(16),

          // Establishment Date
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                AppTexts.businessEstablishmentDateLabel,
                color: AppColors.kDark2,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const Gap(10),
              TextFormField(
                controller: _establishmentDateController,
                readOnly: true,
                onTap: _selectEstablishmentDate,
                validator: ValidatorsUtil.validatePastOrPresentDate,
                decoration: InputDecoration(
                  hintText: AppTexts.selectDateHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.kPrimary500, width: 2),
                  ),
                  suffixIcon: const Icon(Icons.calendar_today_outlined, color: AppColors.kPrimary500),
                ),
              ),
            ],
          ),
          const Gap(16),

          // Industry Dropdown
          _buildDropdownField<IndustriesModel>(
            label: AppTexts.businessIndustryLabel,
            hint: AppTexts.selectIndustryHint,
            value: _selectedIndustry,
            items: IndustriesModel.defaultIndustries,
            itemText: (item) => item.industry,
            onChanged: (val) => setState(() => _selectedIndustry = val),
            validator: (val) => val == null ? AppTexts.emptyIndustryError : null,
          ),
          const Gap(16),

          // Business Type Dropdown
          _buildDropdownField<BusinessesTypeModel>(
            label: AppTexts.businessTypeLabel,
            hint: AppTexts.selectBusinessTypeHint,
            value: _selectedBusinessType,
            items: BusinessesTypeModel.defaultBusinessTypes,
            itemText: (item) => '${item.code} - ${item.type}',
            onChanged: (val) => setState(() => _selectedBusinessType = val),
            validator: (val) => val == null ? AppTexts.emptyBusinessTypeError : null,
          ),
          const Gap(16),

          // Tax Regimen Dropdown
          _buildDropdownField<TypesRegimensTaxesModel>(
            label: AppTexts.businessTaxRegimenLabel,
            hint: AppTexts.selectTaxRegimenHint,
            value: _selectedTaxRegimen,
            items: TypesRegimensTaxesModel.defaultTaxRegimens,
            itemText: (item) => item.regimen,
            onChanged: (val) => setState(() => _selectedTaxRegimen = val),
            validator: (val) => val == null ? AppTexts.emptyTaxRegimenError : null,
          ),
          const Gap(16),

          // Description (Optional)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                '${AppTexts.businessDescriptionLabel} (Opcional)',
                color: AppColors.kDark2,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const Gap(10),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                maxLength: 200,
                validator: ValidatorsUtil.validateBusinessDescription,
                decoration: InputDecoration(
                  hintText: AppTexts.businessDescriptionHint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.kPrimary500, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),

          // Images Section: Logo and Cover
          _buildImageUploaders(),
          const Gap(28),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 140,
                height: 46,
                child: AppButton(
                  text: AppTexts.cancel,
                  onPressed: _handleCancel,
                  backgroundColor: AppColors.kNeutral100,
                  textColor: AppColors.kNeutral700,
                  borderColor: AppColors.kNeutral300,
                ),
              ),
              const Gap(12),
              SizedBox(
                width: 180,
                height: 46,
                child: AppButton(
                  text: isEditing ? AppTexts.update : AppTexts.save,
                  onPressed: _handleSubmit,
                  isLoading: isLoading,
                  backgroundColor: AppColors.kPrimary600,
                  textColor: AppColors.kWhiteColor,
                  leadingWidget: const Icon(Icons.check, color: AppColors.kWhiteColor, size: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required String hint,
    required T? value,
    required List<T> items,
    required String Function(T) itemText,
    required void Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          label,
          color: AppColors.kDark2,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        const Gap(10),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.kPrimary500, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          ),
          hint: Text(hint, style: const TextStyle(fontSize: 14, color: AppColors.kNeutral400)),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemText(item),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: AppColors.kDark2),
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildImageUploaders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          'Imágenes de la Empresa',
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.kDark2,
        ),
        const Gap(4),
        AppText(
          AppTexts.imageDimensionsInfo,
          fontSize: 12,
          color: AppColors.kNeutral500,
        ),
        const Gap(16),

        // Logo Picker
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.kNeutral50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.kNeutral200),
          ),
          child: Row(
            children: [
              // 1:1 Box Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.kNeutral200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.kNeutral300),
                  ),
                  child: _logoBytes != null
                      ? Image.memory(_logoBytes!, fit: BoxFit.cover)
                      : (widget.initialBusiness?.logoUrl != null && widget.initialBusiness!.logoUrl!.isNotEmpty
                          ? Image.network(
                              widget.initialBusiness!.logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.business_outlined, size: 36, color: AppColors.kNeutral500),
                            )
                          : const Icon(Icons.business_outlined, size: 36, color: AppColors.kNeutral500)),
                ),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      AppTexts.businessLogoLabel,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.kDark2,
                    ),
                    const Gap(2),
                    AppText(
                      AppTexts.logoRequirementHint,
                      fontSize: 11,
                      color: AppColors.kNeutral500,
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _pickLogo,
                          icon: const Icon(Icons.upload_file, size: 16),
                          label: Text(_logoFile != null ? AppTexts.change : AppTexts.chooseFile),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.kPrimary600,
                            side: const BorderSide(color: AppColors.kPrimary400),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                        if (_logoFile != null) ...[
                          const Gap(8),
                          TextButton(
                            onPressed: () => setState(() {
                              _logoFile = null;
                              _logoBytes = null;
                            }),
                            child: const Text(AppTexts.remove, style: TextStyle(color: AppColors.kError, fontSize: 13)),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Gap(16),

        // Cover Picker
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.kNeutral50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.kNeutral200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        AppTexts.businessCoverLabel,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.kDark2,
                      ),
                      const Gap(2),
                      AppText(
                        AppTexts.coverRequirementHint,
                        fontSize: 11,
                        color: AppColors.kNeutral500,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: _pickCover,
                        icon: const Icon(Icons.image_outlined, size: 16),
                        label: Text(_coverFile != null ? AppTexts.change : AppTexts.chooseFile),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.kPrimary600,
                          side: const BorderSide(color: AppColors.kPrimary400),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                      if (_coverFile != null) ...[
                        const Gap(8),
                        TextButton(
                          onPressed: () => setState(() {
                            _coverFile = null;
                            _coverBytes = null;
                          }),
                          child: const Text(AppTexts.remove, style: TextStyle(color: AppColors.kError, fontSize: 13)),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              const Gap(10),
              // 16:9 Banner Preview
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.kNeutral200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.kNeutral300),
                    ),
                    child: _coverBytes != null
                        ? Image.memory(_coverBytes!, fit: BoxFit.cover)
                        : (widget.initialBusiness?.coverUrl != null && widget.initialBusiness!.coverUrl!.isNotEmpty
                            ? Image.network(
                                widget.initialBusiness!.coverUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.panorama_outlined, size: 48, color: AppColors.kNeutral400),
                                ),
                              )
                            : const Center(
                                child: Icon(Icons.panorama_outlined, size: 48, color: AppColors.kNeutral400),
                              )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLivePreview() {
    final name = _nameController.text.trim().isEmpty ? 'Nombre de la Empresa' : _nameController.text.trim();
    final rfc = _rfcController.text.trim().isEmpty ? 'RFC: ABC010203XYZ' : 'RFC: ${_rfcController.text.trim().toUpperCase()}';
    final industry = _selectedIndustry?.industry ?? 'Giro / Industria';
    final businessType = _selectedBusinessType?.type ?? 'Tipo de Empresa';
    final taxRegimen = _selectedTaxRegimen?.regimen ?? 'Régimen Fiscal';
    final date = _establishmentDateController.text.trim().isNotEmpty
        ? 'Const.: ${_establishmentDateController.text.trim()}'
        : 'Const.: AAAA-MM-DD';
    final description = _descriptionController.text.trim().isNotEmpty
        ? _descriptionController.text.trim()
        : 'La descripción de las actividades de tu empresa aparecerá aquí...';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.kNeutral200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header / Title of preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            child: Row(
              children: [
                const Icon(Icons.remove_red_eye_outlined, size: 18, color: AppColors.kPrimary600),
                const Gap(8),
                AppText(
                  AppTexts.previewArea,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kDark1,
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.kNeutral200),

          // Cover Image Banner
          Stack(
            clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: 16 / 7,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.kPrimary600, AppColors.kPrimary800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: _coverBytes != null
                      ? Image.memory(_coverBytes!, fit: BoxFit.cover)
                      : (widget.initialBusiness?.coverUrl != null && widget.initialBusiness!.coverUrl!.isNotEmpty
                          ? Image.network(
                              widget.initialBusiness!.coverUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Center(
                                child: Opacity(
                                  opacity: 0.25,
                                  child: Icon(Icons.storefront, size: 64, color: AppColors.kWhiteColor),
                                ),
                              ),
                            )
                          : Center(
                              child: Opacity(
                                opacity: 0.25,
                                child: Icon(Icons.storefront, size: 64, color: AppColors.kWhiteColor),
                              ),
                            )),
                ),
              ),
              // Overlapping Logo Avatar
              Positioned(
                bottom: -28,
                left: 20,
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.kWhiteColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.kWhiteColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _logoBytes != null
                        ? Image.memory(_logoBytes!, fit: BoxFit.cover)
                        : (widget.initialBusiness?.logoUrl != null && widget.initialBusiness!.logoUrl!.isNotEmpty
                            ? Image.network(
                                widget.initialBusiness!.logoUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: AppColors.kPrimary100,
                                  child: const Icon(Icons.business, color: AppColors.kPrimary700, size: 36),
                                ),
                              )
                            : Container(
                                color: AppColors.kPrimary100,
                                child: const Icon(Icons.business, color: AppColors.kPrimary700, size: 36),
                              )),
                  ),
                ),
              ),
            ],
          ),
          const Gap(36),

          // Preview Details
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  name,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.kDark1,
                ),
                const Gap(4),
                AppText(
                  rfc,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.kPrimary700,
                ),
                const Gap(12),

                // Badges
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildChip(icon: Icons.category_outlined, label: industry, color: AppColors.kInfo),
                    _buildChip(icon: Icons.badge_outlined, label: businessType, color: AppColors.kPrimary600),
                    _buildChip(icon: Icons.calendar_today_outlined, label: date, color: AppColors.kDark3),
                  ],
                ),
                const Gap(12),

                // Tax Regimen
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.kNeutral50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.kNeutral200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.account_balance_outlined, size: 16, color: AppColors.kNeutral600),
                      const Gap(8),
                      Expanded(
                        child: Text(
                          taxRegimen,
                          style: const TextStyle(fontSize: 12, color: AppColors.kNeutral700, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),

                // Description
                AppText(
                  description,
                  fontSize: 12,
                  color: AppColors.kNeutral600,
                ),
                const Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const Gap(6),
          Text(
            label,
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
