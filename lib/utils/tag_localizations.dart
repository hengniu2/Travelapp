/// Localized display names for tags (destinations, interests, skills, languages).
/// When locale is 'zh', returns Chinese; otherwise returns the key (English).
/// Use for companion/tour tags so UI respects app language.
class TagLocalizations {
  TagLocalizations._();

  static const Map<String, String> _destinationsZh = {
    'Paris': '巴黎',
    'Rome': '罗马',
    'Barcelona': '巴塞罗那',
    'Tokyo': '东京',
    'Seoul': '首尔',
    'Bangkok': '曼谷',
    'New York': '纽约',
    'London': '伦敦',
    'Amsterdam': '阿姆斯特丹',
    'Beijing': '北京',
    'Sanya': '三亚',
    'Lijiang': '丽江',
    'Guilin': '桂林',
    'Chengdu': '成都',
    'Harbin': '哈尔滨',
    'Chongqing': '重庆',
    'Xishuangbanna': '西双版纳',
    'Brussels': '布鲁塞尔',
    'Berlin': '柏林',
    'Prague': '布拉格',
    'Singapore': '新加坡',
    'Kuala Lumpur': '吉隆坡',
  };

  static const Map<String, String> _interestsZh = {
    'History': '历史',
    'Art': '艺术',
    'Food': '美食',
    'Culture': '文化',
    'Technology': '科技',
    'Architecture': '建筑',
    'Museums': '博物馆',
    'Nightlife': '夜生活',
    'Photography': '摄影',
  };

  static const Map<String, String> _skillsZh = {
    'Photography': '摄影',
    'French': '法语',
    'Guiding': '导游',
    'Japanese': '日语',
    'Planning': '行程规划',
    'English': '英语',
    'Mandarin': '普通话',
    'Dutch': '荷兰语',
    'Spanish': '西班牙语',
  };

  static const Map<String, String> _languagesZh = {
    'English': '英语',
    'French': '法语',
    'Spanish': '西班牙语',
    'Japanese': '日语',
    'Mandarin': '普通话',
    'Dutch': '荷兰语',
  };

  /// Returns localized label for a destination name.
  static String destination(String localeName, String key) {
    if (localeName == 'zh') return _destinationsZh[key] ?? key;
    return key;
  }

  /// Returns localized label for an interest tag.
  static String interest(String localeName, String key) {
    if (localeName == 'zh') return _interestsZh[key] ?? key;
    return key;
  }

  /// Returns localized label for a skill tag.
  static String skill(String localeName, String key) {
    if (localeName == 'zh') return _skillsZh[key] ?? key;
    return key;
  }

  /// Returns localized label for a language name.
  static String language(String localeName, String key) {
    if (localeName == 'zh') return _languagesZh[key] ?? key;
    return key;
  }

  /// For tours: display city name. [zhName] is the Chinese name (e.g. 北京).
  /// Returns [zhName] when zh, English name when en.
  static const Map<String, String> _cityZhToEn = {
    '西双版纳': 'Xishuangbanna',
    '北京': 'Beijing',
    '三亚': 'Sanya',
    '丽江': 'Lijiang',
    '桂林': 'Guilin',
    '成都': 'Chengdu',
    '哈尔滨': 'Harbin',
    '重庆': 'Chongqing',
  };

  static String cityDisplayName(String localeName, String zhName) {
    if (localeName == 'zh') return zhName;
    return _cityZhToEn[zhName] ?? zhName;
  }
}
