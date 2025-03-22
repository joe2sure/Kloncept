// File: lib/model/dummy/dummy_watchlist_model.dart

class DummyWatchlistModel {
  List<DummyWatchlist>? _watchlist;

  List<DummyWatchlist>? get watchlist => _watchlist;

  DummyWatchlistModel({List<DummyWatchlist>? watchlist}) {
    _watchlist = watchlist;
  }

  DummyWatchlistModel.fromJson(dynamic json) {
    if (json['watchlist'] != null) {
      _watchlist = [];
      json['watchlist'].forEach((v) {
        _watchlist!.add(DummyWatchlist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_watchlist != null) {
      map['watchlist'] = _watchlist!.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class DummyWatchlist {
  int? _id;
  String? _userId;
  String? _courseId;
  String? _startTime;
  String? _active;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;
  String? get userId => _userId;
  String? get courseId => _courseId;
  String? get startTime => _startTime;
  String? get active => _active;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  DummyWatchlist({
    required int id,
    required String userId,
    required String courseId,
    required String startTime,
    required String active,
    required String createdAt,
    required String updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _courseId = courseId;
    _startTime = startTime;
    _active = active;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  DummyWatchlist.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _courseId = json['course_id'];
    _startTime = json['start_time'];
    _active = json['active'].toString();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['course_id'] = _courseId;
    map['start_time'] = _startTime;
    map['active'] = _active;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}