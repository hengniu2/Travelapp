// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '旅行应用';

  @override
  String get home => '首页';

  @override
  String get companions => '旅伴';

  @override
  String get tours => '旅游团';

  @override
  String get bookings => '预订';

  @override
  String get content => '内容';

  @override
  String get profile => '个人资料';

  @override
  String get travelCompanions => '旅行旅伴';

  @override
  String get tourGroups => '旅游团';

  @override
  String get travelContent => '旅行内容';

  @override
  String get noCompanionsFound => '未找到旅伴';

  @override
  String get noToursFound => '未找到旅游团';

  @override
  String get noHotelsFound => '未找到酒店';

  @override
  String get noContentFound => '未找到内容';

  @override
  String get companionDetails => '旅伴详情';

  @override
  String get tourDetails => '旅游团详情';

  @override
  String get hotelDetails => '酒店详情';

  @override
  String get available => '可用';

  @override
  String get unavailable => '不可用';

  @override
  String get pricePerDay => '每日价格';

  @override
  String get destinations => '目的地';

  @override
  String get interests => '兴趣';

  @override
  String get skills => '技能';

  @override
  String get languages => '语言';

  @override
  String get chat => '聊天';

  @override
  String get bookNow => '立即预订';

  @override
  String get filter => '筛选';

  @override
  String get search => '搜索';

  @override
  String get searchHotels => '搜索酒店...';

  @override
  String get sort => '排序';

  @override
  String get sortHotels => '排序酒店';

  @override
  String get priceLowToHigh => '价格：从低到高';

  @override
  String get priceHighToLow => '价格：从高到低';

  @override
  String get ratingHighToLow => '评分：从高到低';

  @override
  String get hotels => '酒店';

  @override
  String get tickets => '门票';

  @override
  String get insurance => '保险';

  @override
  String get orders => '订单';

  @override
  String get favorites => '收藏';

  @override
  String get reviews => '评价';

  @override
  String get wallet => '钱包';

  @override
  String get notifications => '通知';

  @override
  String get language => '语言';

  @override
  String get english => 'English';

  @override
  String get chinese => '中文';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get all => '全部';

  @override
  String get guide => '指南';

  @override
  String get tips => '提示';

  @override
  String get travelNotes => '旅行笔记';

  @override
  String get trending => '热门';

  @override
  String get duration => '时长';

  @override
  String days(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '天',
      one: '天',
    );
    return '$_temp0';
  }

  @override
  String maxParticipants(int count) {
    return '最多 $count 人';
  }

  @override
  String get route => '路线';

  @override
  String get description => '描述';

  @override
  String get amenities => '设施';

  @override
  String get location => '位置';

  @override
  String get rating => '评分';

  @override
  String get views => '浏览';

  @override
  String get likes => '点赞';

  @override
  String get author => '作者';

  @override
  String get publishDate => '发布日期';

  @override
  String get guest => '访客';
}
