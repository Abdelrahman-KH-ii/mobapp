import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  bool get isArabic => locale.languageCode == 'ar';

  String convertNumbers(String input) {
    if (!isArabic) return input;
    const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    String result = input;
    for (int i = 0; i < english.length; i++) {
      result = result.replaceAll(english[i], arabic[i]);
    }
    return result;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // ── App ──
      'app_name': 'FarmTec',
      'tagline': 'Precision Intelligence for the Modern Farm',

      // ── Auth ──
      'welcome_back': 'Welcome Back',
      'sign_in_subtitle':
          'Sign in to manage your precision agriculture ecosystem.',
      'create_account': 'Create Account',
      'sign_up_subtitle':
          'Enter your details to start monitoring your digital ecosystem.',
      'email_address': 'Email Address',
      'password': 'Password',
      'forgot_password': 'Forgot Password?',
      'full_name': 'Full Name',
      'phone_number': 'Phone Number',
      'farm_name': 'Farm Name',
      'location_region': 'Location / Region',
      'user_role': 'User Role',
      'role_farmer': 'Farmer',
      'role_expert': 'Agricultural Expert',
      'role_student': 'Student',
      'login_button': 'Login To Dashboard',
      'signup_button': 'Sign Up',
      'no_account': "Don't have an account? ",
      'sign_up': 'Sign Up',
      'have_account': 'Already have an account? ',
      'login': 'Login',
      'or': 'OR',
      'terms_prefix': 'By signing up, you agree to our ',
      'terms_of_service': 'Terms of Service',
      'and': ' and ',
      'privacy_policy': 'Privacy Policy',

      // ── Navigation ──
      'dashboard': 'Dashboard',
      'my_farm': 'My Farm',
      'ai_models': 'AI Models',
      'market': 'Market',
      'chat': 'Chat',

      // ── Farm Selection ──
      'select_farm': 'Select Your Farm',
      'select_farm_subtitle': 'Choose a farm to manage or add a new one',
      'add_first_farm': 'Add Your First Farm',
      'add_first_farm_desc': 'Get started by adding your farm details',
      'add_farm': 'Add Farm',
      'add_field': 'Add Field',
      'continue_text': 'Continue',
      'farms_tab': 'Farms',
      'farms': 'Farms',
      'activity_tab': 'Recent Activity',
      'recent_activity': 'Recent Activity',

      // ── Dashboard ──
      'good_morning': 'Good Morning 🌱',
      'soil_metrics': 'Soil Metrics',
      'ai_recommendation': 'AI Recommendation',
      'active_processes': 'Active Processes',
      'market_snapshot': 'Market Snapshot',
      'weather': 'Weather',
      'nitrogen': 'Nitrogen',
      'phosphorus': 'Phosphorus',
      'potassium': 'Potassium',
      'moisture': 'Moisture',
      'humidity': 'Humidity',
      'precipitation': 'Precipitation',
      'wind': 'Wind',
      'soil_temp': 'Soil Temp',
      'optimal': 'Optimal',
      'for_growth': 'FOR GROWTH',
      'apply_now': 'Apply Now',
      'schedule': 'Schedule',
      'nitrogen_tip': 'Essential element for plant leaf growth',
      'phosphorus_tip': 'Supports root development and flowering',
      'potassium_tip': 'Strengthens the plant and improves disease resistance',
      'ph_tip': 'Measures soil acidity/alkalinity (ideal: 6.0-7.0)',
      'disease_scan': 'Disease Scan',
      'analyzing': 'Analyzing...',
      'yield_prediction': 'Yield Prediction',
      'complete': 'Complete',

      // ── AI Models ──
      'ai_engine': 'FarmBrain AI Engine',
      'all_models_ready': 'All models ready',
      'live': 'LIVE',
      'available_models': 'Available Models',
      'recent_analyses': 'Recent Analyses',
      'crop_recommendation': 'Crop Recommendation',
      'crop_recommendation_desc': 'Predicts optimal crop based on GPS location',
      'disease_detection': 'Disease Detection',
      'disease_detection_desc':
          'Upload crop photos for instant disease identification.',
      'yield_prediction_desc':
          'Forecasts crop yield from location, year & crop type',
      'nutrient_optimizer': 'Nutrient Optimizer',
      'nutrient_optimizer_desc':
          'Precise fertilizer recommendations for each field block.',
      'weather_forecast': 'Weather Forecast',
      'weather_forecast_desc':
          'Hyperlocal 14-day forecast for precision planning.',
      'irrigation_planner': 'Irrigation Planner',
      'irrigation_planner_desc':
          'Calculates irrigation needs from GPS coordinates',
      'market_forecast': 'Market Forecast',
      'market_forecast_desc': 'Commodity price forecast from live market data',
      'current_values': 'Current Values',
      'run_model': 'Run Model',
      'run_prediction': 'Run Prediction',
      'model_inputs': 'Model Inputs',
      'input_parameters': 'Input Parameters',
      'uses_defaults': 'Uses defaults if left empty',
      'prediction_results': 'Prediction Results',
      'confidence': 'Confidence',
      'tap_model_subtitle': 'Tap a model to run live predictions',
      'connected_to_api': 'Connected to HuggingFace APIs',
      'get_request': 'GET request',
      'parameters': 'parameters',

      // ── Market ──
      'market_prices': 'Market Prices',
      'market_subtitle': 'Live commodity prices · Updated every 15 min',
      'forecast_details': 'Forecast Details',
      'current_price': 'Current Price',
      'failed_to_load_market': 'Failed to load market prices.',
      'per_ton': '/t',
      'wheat': 'Wheat',
      'maize': 'Maize',
      'rice': 'Rice',
      'mango': 'Mango',
      'potato': 'Potato',
      'tomato': 'Tomato',
      'jowar_(sorghum)': 'Jowar (Sorghum)',
      'green_fodder': 'Green Fodder',
      'field_alpha': 'Field Alpha',
      'field_beta': 'Field Beta',
      'field_gamma': 'Field Gamma',
      'model_training_complete': 'Model training complete',

      // ── My Farm ──
      'all_fields': 'All Fields',
      'total_area': 'Total Area',
      'healthy_fields': 'Healthy Fields',
      'alerts': 'Alerts',
      'healthy': 'Healthy',
      'warning': 'Warning',
      'critical': 'Critical',
      'field_name': 'Field Name',
      'latitude': 'Latitude',
      'longitude': 'Longitude',
      'use_gps': 'Use Current GPS Location',
      'fetching_gps': 'Fetching GPS...',
      'crop_type': 'Crop Type',
      'area_hectares': 'Area (hectares)',
      'add_new_field': 'Add New Field',
      'field_added': '✅ Field added!',
      'no_farm_selected': 'No farm selected',
      'farm_details': 'Current farm details & overview',
      'farm_overview': 'Farm Overview',
      'location': 'Location',
      'no_recent_activity': 'No recent activity',
      'health': 'Health',
      'last_scan': 'Last Scan',

      // ── Farm History ──
      'history': 'History',
      'recent_operations': 'Recent Operations',
      'no_operations': 'No operations yet',
      'fertilizer_applied': 'Fertilizer Applied',
      'irrigation_completed': 'Irrigation Completed',
      'disease_scan_run': 'Disease Scan Run',
      'crop_planted': 'Crop Planted',
      'weather_alert': 'Weather Alert',
      'farm_created': 'Farm Created',
      'op_ai_crop_recommendation': 'Crop Recommendation',
      'op_ai_yield_prediction': 'Yield Prediction',
      'op_ai_irrigation_planner': 'Irrigation Planner',
      'op_ai_market_forecast': 'Market Forecast',
      'no_activity_yet': 'No activity yet',
      'activity_on_farm': 'Farm: {farm}',
      'ndvi_scan': 'NDVI Scan',
      'ndvi_scan_result': 'Avg NDVI {value}',
      'ndvi_no_location': 'Add GPS coordinates to run an NDVI scan',
      'ndvi_analyzing': 'Analyzing vegetation...',
      'ndvi_healthy': 'Healthy',
      'ndvi_stressed': 'Stressed',
      'gps_coordinates': 'GPS Coordinates',
      'lat_lng_format': 'Lat: {lat}  ·  Lng: {lng}',
      'lat_lng_format_ar': 'Lat: {lat} · Lng: {lng}',
      'planting_date': 'Planting Date',
      'select_planting_date': 'Select planting date',
      'crop_lifecycle': 'Crop Lifecycle',
      'profit_calculator': 'Profit Calculator',
      'estimated_yield': 'Estimated Yield',
      'current_market_price': 'Current Market Price',
      'source': 'Source',
      'total_expected_profit': 'Total Expected Profit',
      'day_n': 'Day {n}',
      'sowing': 'Sowing',
      'expected_harvest': 'Expected Harvest',
      'set_planting_date_hint': 'Set a planting date when adding your farm',
      'map_preview': 'Map Preview',
      'map_satellite_attribution': '© Mapbox © Maxar',
      'tap_map_set_location': 'Tap map to set location',
      'about': 'About',
      'auto_filled_gps': 'Auto-filled from your farm GPS',
      'api_error': 'API Error {code}',
      'connection_error':
          'Could not connect. Model may be sleeping — retry in 30s.',
      'clear_all': 'Clear All',
      'no_notifications': 'No notifications',
      'time_ago_minutes': '{n}m ago',
      'time_ago_hours': '{h}h ago',
      'time_ago_days': '{d}d ago',
      'task_automation': 'Task Automation',
      'location_fetch_failed': 'Failed to get location',
      'year': 'Year',
      'notifications_off': 'Notifications are turned off.',
      'no_notifications_match':
          'No notifications match your alert settings.',

      // ── Chat ──
      'farmbrain_ai': 'FarmBrain AI',
      'ask_anything': 'Ask FarmBrain anything...',
      'new_chat': 'New Chat',
      'chat_history': 'Chat History',
      'suggestion_analyze': '🌿 Analyze Field',
      'suggestion_irrigation': '💧 Irrigation schedule',
      'suggestion_disease': '🦠 Disease check',
      'suggestion_market': '📈 Market update',
      'suggestion_crop': '🌱 Crop recommendation',

      // ── Profile / Settings ──
      'profile': 'Profile',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'english': 'English',
      'arabic': 'العربية',
      'notifications': 'Notifications',
      'logout': 'Logout',
      'sign_out': 'Sign Out',
      'sign_out_confirm': 'Sign Out?',
      'sign_out_message':
          'You will need to log in again to access your farm data.',
      'edit_profile': 'Edit Profile',
      'change_password': 'Change Password',
      'save_changes': 'Save Changes',
      'update_password': 'Update Password',
      'current_password': 'Current Password',
      'new_password': 'New Password',
      'confirm_password': 'Confirm Password',
      'profile_updated': 'Profile updated!',
      'appearance': 'Appearance',
      'account': 'Account',
      'support': 'Support',
      'help_faq': 'Help & FAQ',
      'about_us': 'About Us',
      'contact': 'Contact',
      'app_version': 'App Version',
      'farm_statistics': 'Farm Statistics',
      'efficiency': 'Efficiency',
      'push_notifications': 'Push Notifications',
      'weather_alerts': 'Weather Alerts',
      'market_price_alerts': 'Market Price Alerts',
      'disease_alerts': 'Disease Alerts',

      // ── General ──
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'done': 'Done',
      'failed_to_load': 'Failed to load data',
      'synchronizing': 'SYNCHRONIZING SOIL DATA',
      'version': '@FarmTec v2.0',
    },
    'ar': {
      // ── App ──
      'app_name': 'فارم تك',
      'tagline': 'ذكاء زراعي متقدّم لمزرعتك',

      // ── Auth ──
      'welcome_back': 'مرحباً بعودتك',
      'sign_in_subtitle': 'سجّل دخولك لإدارة مزرعتك الذكية.',
      'create_account': 'إنشاء حساب جديد',
      'sign_up_subtitle': 'أدخل بياناتك لبدء إدارة مزرعتك.',
      'email_address': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'forgot_password': 'نسيت كلمة المرور؟',
      'full_name': 'الاسم الكامل',
      'phone_number': 'رقم الهاتف',
      'farm_name': 'اسم المزرعة',
      'location_region': 'الموقع / المنطقة',
      'user_role': 'نوع المستخدم',
      'role_farmer': 'مزارع',
      'role_expert': 'مهندس زراعي',
      'role_student': 'طالب',
      'login_button': 'دخول',
      'signup_button': 'إنشاء حساب',
      'no_account': 'ليس لديك حساب؟ ',
      'sign_up': 'سجّل الآن',
      'have_account': 'لديك حساب بالفعل؟ ',
      'login': 'تسجيل الدخول',
      'or': 'أو',
      'terms_prefix': 'بالتسجيل، أنت توافق على ',
      'terms_of_service': 'شروط الاستخدام',
      'and': ' و ',
      'privacy_policy': 'سياسة الخصوصية',

      // ── Navigation ──
      'dashboard': 'الرئيسية',
      'my_farm': 'مزرعتي',
      'ai_models': 'الذكاء الاصطناعي',
      'market': 'السوق',
      'chat': 'المحادثة',

      // ── Farm Selection ──
      'select_farm': 'اختر مزرعتك',
      'select_farm_subtitle': 'اختر مزرعة لإدارتها أو أضف واحدة جديدة',
      'add_first_farm': 'أضف مزرعتك الأولى',
      'add_first_farm_desc': 'ابدأ بإضافة تفاصيل مزرعتك',
      'add_farm': 'إضافة مزرعة',
      'add_field': 'إضافة حقل',
      'continue_text': 'متابعة',
      'farms_tab': 'المزارع',
      'farms': 'المزارع',
      'activity_tab': 'آخر الأنشطة',
      'recent_activity': 'آخر الأنشطة',

      // ── Dashboard ──
      'good_morning': 'صباح الخير 🌱',
      'soil_metrics': 'تحليل التربة',
      'ai_recommendation': 'توصية ذكية',
      'active_processes': 'العمليات الجارية',
      'market_snapshot': 'نظرة على الأسعار',
      'weather': 'حالة الطقس',
      'nitrogen': 'نيتروجين (N)',
      'phosphorus': 'فوسفور (P)',
      'potassium': 'بوتاسيوم (K)',
      'moisture': 'رطوبة التربة',
      'humidity': 'رطوبة الجو',
      'precipitation': 'كمية الأمطار',
      'wind': 'سرعة الرياح',
      'soil_temp': 'حرارة التربة',
      'optimal': 'مثالي',
      'for_growth': 'للنمو',
      'apply_now': 'تطبيق الآن',
      'schedule': 'جدولة',
      'nitrogen_tip': 'عنصر أساسي لنمو أوراق النبات وزيادة اللون الأخضر',
      'phosphorus_tip': 'يساعد على نمو الجذور وتكوين الأزهار والثمار',
      'potassium_tip': 'يقوّي النبات ويزيد مقاومته للأمراض والجفاف',
      'ph_tip': 'درجة حموضة التربة — المثالي بين ٦.٠ و ٧.٠',
      'disease_scan': 'فحص الأمراض',
      'analyzing': 'جارِ التحليل...',
      'yield_prediction': 'توقع المحصول',
      'complete': 'مكتمل',

      // ── AI Models ──
      'ai_engine': 'محرك فارم برين',
      'all_models_ready': 'جميع النماذج جاهزة',
      'live': 'مباشر',
      'available_models': 'النماذج المتاحة',
      'recent_analyses': 'تحليلات سابقة',
      'crop_recommendation': 'اقتراح المحصول الأنسب',
      'crop_recommendation_desc':
          'يقترح أفضل محصول بناءً على موقع الأرض والطقس.',
      'disease_detection': 'كشف أمراض النبات',
      'disease_detection_desc': 'ارفع صورة النبات للتعرف على المرض فوراً.',
      'yield_prediction_desc':
          'يتوقع كمية الإنتاج من الموقع ونوع المحصول والسنة.',
      'nutrient_optimizer': 'تحسين تغذية التربة',
      'nutrient_optimizer_desc':
          'يحدد الأسمدة المناسبة وكميتها لكل جزء من الأرض.',
      'weather_forecast': 'توقعات الطقس',
      'weather_forecast_desc': 'توقعات دقيقة لـ١٤ يوم لمنطقتك.',
      'irrigation_planner': 'تخطيط الري',
      'irrigation_planner_desc':
          'يحسب كمية المياه المطلوبة بناءً على حالة التربة.',
      'market_forecast': 'توقعات الأسعار',
      'market_forecast_desc': 'يعرض توقعات أسعار المحاصيل في السوق.',
      'current_values': 'القيم الحالية',
      'run_model': 'تشغيل التحليل',
      'run_prediction': 'ابدأ التحليل',
      'model_inputs': 'البيانات المطلوبة',
      'input_parameters': 'البيانات المطلوبة',
      'uses_defaults': 'ستُستخدم قيم تلقائية إن تُركت فارغة',
      'prediction_results': 'نتائج التحليل',
      'confidence': 'نسبة الدقة',
      'tap_model_subtitle': 'اضغط على أي نموذج لبدء التحليل',
      'connected_to_api': 'متصل بخوادم الذكاء الاصطناعي',
      'get_request': 'طلب تلقائي',
      'parameters': 'بيانات مطلوبة',

      // ── Market ──
      'market_prices': 'أسعار المحاصيل',
      'market_subtitle': 'أسعار حية · تحديث كل ١٥ دقيقة',
      'forecast_details': 'تفاصيل التوقعات',
      'current_price': 'السعر الحالي',
      'failed_to_load_market': 'فشل تحميل أسعار السوق.',
      'per_ton': '/طن',
      'wheat': 'قمح',
      'maize': 'ذرة',
      'rice': 'أرز',
      'mango': 'مانجو',
      'potato': 'بطاطس',
      'tomato': 'طماطم',
      'jowar_(sorghum)': 'ذرة رفيعة (سورغم)',
      'green_fodder': 'علف أخضر',
      'field_alpha': 'الحقل ألفا',
      'field_beta': 'الحقل بيتا',
      'field_gamma': 'الحقل جاما',
      'model_training_complete': 'اكتمل تدريب النموذج',

      // ── My Farm ──
      'all_fields': 'جميع الحقول',
      'total_area': 'المساحة الإجمالية',
      'healthy_fields': 'حقول بحالة جيدة',
      'alerts': 'تنبيهات',
      'healthy': 'بحالة جيدة',
      'warning': 'يحتاج انتباه',
      'critical': 'حالة حرجة',
      'field_name': 'اسم الحقل',
      'latitude': 'خط العرض',
      'longitude': 'خط الطول',
      'use_gps': 'استخدم موقعي الحالي (GPS)',
      'fetching_gps': 'جارِ تحديد الموقع...',
      'crop_type': 'نوع المحصول',
      'area_hectares': 'المساحة (هكتار)',
      'add_new_field': 'إضافة حقل جديد',
      'field_added': '✅ تمت الإضافة بنجاح!',
      'no_farm_selected': 'لم يتم اختيار مزرعة',
      'farm_details': 'تفاصيل المزرعة الحالية',
      'farm_overview': 'نظرة عامة على المزرعة',
      'location': 'الموقع',
      'no_recent_activity': 'لا يوجد نشاط حديث',
      'health': 'الحالة الصحية',
      'last_scan': 'آخر فحص',

      // ── Farm History ──
      'history': 'السجل',
      'recent_operations': 'آخر العمليات',
      'no_operations': 'لا توجد عمليات بعد',
      'fertilizer_applied': 'تم وضع السماد',
      'irrigation_completed': 'تم الري',
      'disease_scan_run': 'تم فحص النبات',
      'crop_planted': 'تمت الزراعة',
      'weather_alert': 'تنبيه طقس',
      'farm_created': 'تم إنشاء المزرعة',
      'op_ai_crop_recommendation': 'اقتراح المحصول',
      'op_ai_yield_prediction': 'توقع المحصول',
      'op_ai_irrigation_planner': 'تخطيط الري',
      'op_ai_market_forecast': 'توقعات السوق',
      'no_activity_yet': 'لا يوجد نشاط بعد',
      'activity_on_farm': 'المزرعة: {farm}',
      'ndvi_scan': 'فحص NDVI',
      'ndvi_scan_result': 'متوسط NDVI {value}',
      'ndvi_no_location': 'أضف إحداثيات GPS لتشغيل فحص NDVI',
      'ndvi_analyzing': 'جارِ تحليل الغطاء النباتي...',
      'ndvi_healthy': 'صحي',
      'ndvi_stressed': 'مجهد',
      'gps_coordinates': 'إحداثيات GPS',
      'lat_lng_format': 'خط العرض: {lat} · خط الطول: {lng}',
      'lat_lng_format_ar': 'خط العرض: {lat} · خط الطول: {lng}',
      'planting_date': 'تاريخ الزراعة',
      'select_planting_date': 'اختر تاريخ الزراعة',
      'crop_lifecycle': 'دورة حياة المحصول',
      'profit_calculator': 'حاسبة الأرباح',
      'estimated_yield': 'المحصول المقدر',
      'current_market_price': 'سعر السوق الحالي',
      'source': 'المصدر',
      'total_expected_profit': 'إجمالي الربح المتوقع',
      'day_n': 'اليوم {n}',
      'sowing': 'البذر',
      'expected_harvest': 'الحصاد المتوقع',
      'set_planting_date_hint': 'حدد تاريخ الزراعة عند إضافة المزرعة',
      'map_preview': 'معاينة الخريطة',
      'map_satellite_attribution': '© Mapbox © Maxar',
      'tap_map_set_location': 'اضغط على الخريطة لتحديد الموقع',
      'about': 'حول',
      'auto_filled_gps': 'يملأ تلقائيًا من GPS المزرعة',
      'api_error': 'خطأ API {code}',
      'connection_error':
          'تعذّر الاتصال. قد يكون النموذج في وضع السكون — أعد المحاولة بعد 30 ثانية.',
      'clear_all': 'مسح الكل',
      'no_notifications': 'لا توجد إشعارات',
      'time_ago_minutes': 'منذ {n} دقيقة',
      'time_ago_hours': 'منذ {h} ساعة',
      'time_ago_days': 'منذ {d} يوم',
      'task_automation': 'المهام الآلية',
      'location_fetch_failed': 'فشل الحصول على الموقع',
      'year': 'السنة',
      'notifications_off': 'الإشعارات معطّلة.',
      'no_notifications_match': 'لا توجد إشعارات تطابق إعداداتك.',

      // ── Chat ──
      'farmbrain_ai': 'المساعد الذكي',
      'ask_anything': 'اسأل أي سؤال عن مزرعتك...',
      'new_chat': 'محادثة جديدة',
      'chat_history': 'المحادثات السابقة',
      'suggestion_analyze': '🌿 فحص الحقل',
      'suggestion_irrigation': '💧 جدول الري',
      'suggestion_disease': '🦠 كشف الأمراض',
      'suggestion_market': '📈 أسعار اليوم',
      'suggestion_crop': '🌱 اقتراح محصول',

      // ── Profile / Settings ──
      'profile': 'الملف الشخصي',
      'settings': 'الإعدادات',
      'dark_mode': 'الوضع الداكن',
      'language': 'اللغة',
      'english': 'English',
      'arabic': 'العربية',
      'notifications': 'الإشعارات',
      'logout': 'تسجيل الخروج',
      'sign_out': 'تسجيل الخروج',
      'sign_out_confirm': 'تسجيل الخروج؟',
      'sign_out_message':
          'ستحتاج لتسجيل الدخول مجدداً للوصول إلى بيانات مزرعتك.',
      'edit_profile': 'تعديل الملف الشخصي',
      'change_password': 'تغيير كلمة المرور',
      'save_changes': 'حفظ التعديلات',
      'update_password': 'تحديث كلمة المرور',
      'current_password': 'كلمة المرور الحالية',
      'new_password': 'كلمة المرور الجديدة',
      'confirm_password': 'تأكيد كلمة المرور',
      'profile_updated': 'تم تحديث الملف الشخصي!',
      'appearance': 'المظهر',
      'account': 'الحساب',
      'support': 'المساعدة والدعم',
      'help_faq': 'الأسئلة الشائعة',
      'about_us': 'من نحن',
      'contact': 'اتصل بنا',
      'app_version': 'إصدار التطبيق',
      'farm_statistics': 'إحصائيات المزرعة',
      'efficiency': 'الكفاءة',
      'push_notifications': 'إشعارات فورية',
      'weather_alerts': 'تنبيهات الطقس',
      'market_price_alerts': 'تنبيهات الأسعار',
      'disease_alerts': 'تنبيهات الأمراض',

      // ── General ──
      'loading': 'جارِ التحميل...',
      'error': 'حدث خطأ',
      'retry': 'إعادة المحاولة',
      'cancel': 'إلغاء',
      'confirm': 'تأكيد',
      'save': 'حفظ',
      'delete': 'حذف',
      'edit': 'تعديل',
      'done': 'تم',
      'failed_to_load': 'تعذّر تحميل البيانات',
      'synchronizing': 'جارِ مزامنة بيانات التربة',
      'version': '@فارم تك v2.0',
    },
  };

  String tr(String key) {
    return _localizedValues[locale.languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  /// Translates [key] when present; otherwise returns [fallback] unchanged.
  String trOr(String? key, String fallback) {
    if (key == null || key.isEmpty) return fallback;
    final value = tr(key);
    return value == key ? fallback : value;
  }

  String trParams(String key, Map<String, String> params) {
    var value = tr(key);
    params.forEach((k, v) {
      value = value.replaceAll('{$k}', v);
    });
    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'ar'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
