import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// A lightweight, manual localization system used by the app.
///
/// Instead of generating ARB files and running Flutter’s intl tools,
/// this project keeps things simple by defining translations
/// directly in a Dart map.
///
/// Supported languages:
/// • English (en)
/// • French (fr)
/// • Arabic  (ar)
///
/// Each text string in the UI corresponds to a key in `_localizedValues`,
/// and widgets access translations through getters such as:
///   AppLocalizations.of(context).offersTitle
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  /// Retrieves the localization object from the widget tree.
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  /// A dictionary of language codes → key/value translation maps.
  ///
  /// This allows us to manually return translated strings without
  /// using code generation. If a key is missing in a language,
  /// the system gracefully falls back to English.
  static const _localizedValues = <String, Map<String, String>>{
    'en': {
      'offers_title': 'Purchase Offers',
      'offers_button': 'Purchase Offers',
      'home_title': 'Group Project Home',
      'new_offer': 'New Offer',
      'save_offer': 'Save Offer',
      'update_offer': 'Update Offer',
      'customer_id': 'Customer ID',
      'item_id': 'Boat or Car ID',
      'price_offered': 'Price offered',
      'date_of_offer': 'Date of offer',
      'accepted': 'Accepted?',
      'copyprev_title': 'Copy previous offer?',
      'copyprev_msg':
      'Do you want to copy the fields from the last created offer, or start with an empty form?',
      'blank': 'Blank',
      'copy': 'Copy',
      'delete_offer': 'Delete offer?',
      'delete_offer_msg': 'Are you sure you want to delete this offer?',
      'cancel': 'Cancel',
      'delete': 'Delete',
      'offer_added': 'Offer added',
      'offer_updated': 'Offer updated',
      'offer_deleted': 'Offer deleted',
      'req': 'Required',
      'enter_number': 'Enter a number',
      'offers_help_title': 'How to Use This Page',
      'offers_help_body':
      '• Tap the + button to create a new offer.\n'
          '• Tap an existing offer to edit or delete it.\n'
          '• Offers are saved in the database and reloaded on restart.',
      'form_help_title': 'How to Use This Page',
      'form_help_body':
      '• Fill all fields to create a new offer.\n'
          '• Tap the calendar icon to choose a date.\n'
          '• Use the switch to mark offer as accepted.\n'
          '• In edit mode, tap the trash icon to delete.',
    },
    'fr': {
      'offers_title': 'Offres d’achat',
      'offers_button': 'Offres d’achat',
      'home_title': 'Accueil du projet',
      'new_offer': 'Nouvelle offre',
      'save_offer': 'Enregistrer l’offre',
      'update_offer': 'Mettre à jour l’offre',
      'customer_id': 'ID client',
      'item_id': 'ID bateau ou voiture',
      'price_offered': 'Prix proposé',
      'date_of_offer': 'Date de l’offre',
      'accepted': 'Acceptée ?',
      'copyprev_title': 'Copier la dernière offre ?',
      'copyprev_msg':
      'Voulez-vous copier les champs de la dernière offre ou commencer avec un formulaire vide ?',
      'blank': 'Vide',
      'copy': 'Copier',
      'delete_offer': 'Supprimer l’offre ?',
      'delete_offer_msg':
      'Êtes-vous sûr de vouloir supprimer cette offre ?',
      'cancel': 'Annuler',
      'delete': 'Supprimer',
      'offer_added': 'Offre ajoutée',
      'offer_updated': 'Offre mise à jour',
      'offer_deleted': 'Offre supprimée',
      'req': 'Obligatoire',
      'enter_number': 'Entrer un nombre',
      'offers_help_title': 'Comment utiliser cette page',
      'offers_help_body':
      '• Appuyez sur + pour créer une nouvelle offre.\n'
          '• Appuyez sur une offre pour la modifier ou la supprimer.\n'
          '• Les offres sont enregistrées dans la base de données.',
      'form_help_title': 'Comment utiliser cette page',
      'form_help_body':
      '• Remplissez tous les champs.\n'
          '• Utilisez l’icône du calendrier pour choisir une date.\n'
          '• Utilisez l’interrupteur pour marquer l’offre comme acceptée.\n'
          '• En mode édition, utilisez la corbeille pour supprimer.',
    },
    'ar': {
      'offers_title': 'عروض الشراء',
      'offers_button': 'عروض الشراء',
      'home_title': 'الصفحة الرئيسية للمشروع',
      'new_offer': 'عرض جديد',
      'save_offer': 'حفظ العرض',
      'update_offer': 'تحديث العرض',
      'customer_id': 'رقم الزبون',
      'item_id': 'رقم السيارة أو القارب',
      'price_offered': 'السعر المقترح',
      'date_of_offer': 'تاريخ العرض',
      'accepted': 'مقبول؟',
      'copyprev_title': 'نسخ العرض السابق؟',
      'copyprev_msg':
      'هل تريد نسخ معلومات آخر عرض تم إنشاؤه أم البدء بنموذج فارغ؟',
      'blank': 'فارغ',
      'copy': 'نسخ',
      'delete_offer': 'حذف العرض؟',
      'delete_offer_msg': 'هل أنت متأكد أنك تريد حذف هذا العرض؟',
      'cancel': 'إلغاء',
      'delete': 'حذف',
      'offer_added': 'تم إضافة العرض',
      'offer_updated': 'تم تحديث العرض',
      'offer_deleted': 'تم حذف العرض',
      'req': 'حقل إجباري',
      'enter_number': 'أدخل رقمًا',
      'offers_help_title': 'كيفية استخدام هذه الصفحة',
      'offers_help_body':
      '• اضغط على زر + لإضافة عرض جديد.\n'
          '• اضغط على أي عرض لتعديله أو حذفه.\n'
          '• يتم حفظ العروض في قاعدة البيانات وإعادة تحميلها عند إعادة التشغيل.',
      'form_help_title': 'كيفية استخدام هذه الصفحة',
      'form_help_body':
      '• املأ كل الحقول.\n'
          '• استخدم رمز التقويم لاختيار التاريخ.\n'
          '• استخدم المفتاح لتحديد ما إذا كان العرض مقبولاً.\n'
          '• في وضع التعديل، استخدم أيقونة الحذف لإزالة العرض.',
    },
  };

  /// Internal helper that fetches a translation using the current locale.
  ///
  /// If the current language doesn’t contain a translation for the given key,
  /// the method falls back to English to avoid crashing.
  String _t(String key) {
    final lang = _localizedValues[locale.languageCode] ?? _localizedValues['en']!;
    return lang[key] ?? key;
  }

  // ===== Public getters used throughout the UI =====
  // (These make widget code cleaner and avoid typing map keys everywhere)

  String get offersTitle => _t('offers_title');
  String get offersButton => _t('offers_button');
  String get homeTitle => _t('home_title');
  String get newOffer => _t('new_offer');
  String get saveOffer => _t('save_offer');
  String get updateOffer => _t('update_offer');
  String get customerId => _t('customer_id');
  String get itemId => _t('item_id');
  String get priceOffered => _t('price_offered');
  String get dateOfOffer => _t('date_of_offer');
  String get accepted => _t('accepted');
  String get copyPrevTitle => _t('copyprev_title');
  String get copyPrevMsg => _t('copyprev_msg');
  String get blank => _t('blank');
  String get copy => _t('copy');
  String get deleteOffer => _t('delete_offer');
  String get deleteOfferMsg => _t('delete_offer_msg');
  String get cancel => _t('cancel');
  String get delete => _t('delete');
  String get offerAdded => _t('offer_added');
  String get offerUpdated => _t('offer_updated');
  String get offerDeleted => _t('offer_deleted');
  String get required => _t('req');
  String get enterNumber => _t('enter_number');
  String get offersHelpTitle => _t('offers_help_title');
  String get offersHelpBody => _t('offers_help_body');
  String get formHelpTitle => _t('form_help_title');
  String get formHelpBody => _t('form_help_body');

  /// Localization delegates needed by Flutter’s MaterialApp.
  ///
  /// These are required so Material, Cupertino, DatePicker, etc.
  /// also display translated built-in UI strings.
  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => const [
    AppLocalizationsDelegate(),
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// List of all languages this app supports.
  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('fr'),
    Locale('ar'),
  ];
}

/// Provides AppLocalizations to the widget tree.
///
/// Flutter automatically calls [load] when the user changes language
/// or when the app first starts.
class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'fr', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
