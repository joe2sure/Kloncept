import '../provider/full_course_detail.dart';

class VideoClip {
  final String? fileName;
  final String? thumbName;
  final String? title;
  final String? parent;
  final int? runningTime;
  final int? id;
  final String? instructor;
  final DateTime? dateTime;
  final String? subtitle;
  final bool? isIframe;

  VideoClip(this.title, this.fileName, this.thumbName, this.runningTime,
      this.parent, this.id, this.instructor, this.dateTime, this.subtitle,
      {this.isIframe = false});

  String videoPath() {
    return "$parent/$fileName";
  }

  String thumbPath() {
    return "$parent/$thumbName";
  }
}

class Section {
  Chapter? sectionDetails;
  List<VideoClip>? sectionLessons;
  Section(this.sectionDetails, this.sectionLessons);
}
