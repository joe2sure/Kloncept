class ContentModel {
  ContentModel({
    this.overview,
    this.quiz,
    this.announcement,
    this.assignment,
    this.questions,
    this.appointment,
    this.papers,
    this.googleMeet,
    this.jitsiMeeting,
  });

  List<Overview>? overview;
  List<Quiz>? quiz;
  List<Announcement>? announcement;
  List<Assignment>? assignment;
  List<ContentModelQuestion>? questions;
  List<Appointment>? appointment;
  List<Papers>? papers;
  List<GoogleMeet>? googleMeet;
  List<JitsiMeeting>? jitsiMeeting;

  factory ContentModel.fromJson(Map<String, dynamic> json) => ContentModel(
        overview: List<Overview>.from(
            json["overview"].map((x) => Overview.fromJson(x))),
        quiz: List<Quiz>.from(json["quiz"].map((x) => Quiz.fromJson(x))),
        announcement: List<Announcement>.from(
            json["announcement"].map((x) => Announcement.fromJson(x))),
        assignment: List<Assignment>.from(
            json["assignment"].map((x) => Assignment.fromJson(x))),
        questions: List<ContentModelQuestion>.from(
            json["questions"].map((x) => ContentModelQuestion.fromJson(x))),
        appointment: List<Appointment>.from(
            json["appointment"].map((x) => Appointment.fromJson(x))),
        papers:
            List<Papers>.from(json["papers"].map((x) => Papers.fromJson(x))),
        googleMeet: List<GoogleMeet>.from(
            json["google_meet"].map((x) => GoogleMeet.fromJson(x))),
        jitsiMeeting: List<JitsiMeeting>.from(
            json["jitsi_meeting"].map((x) => JitsiMeeting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "overview": List<dynamic>.from(overview!.map((x) => x.toJson())),
        "quiz": List<dynamic>.from(quiz!.map((x) => x.toJson())),
        "announcement":
            List<dynamic>.from(announcement!.map((x) => x.toJson())),
        "assignment": List<dynamic>.from(assignment!.map((x) => x.toJson())),
        "questions": List<dynamic>.from(questions!.map((x) => x.toJson())),
        "appointment": List<dynamic>.from(appointment!.map((x) => x.toJson())),
        "papers": List<dynamic>.from(papers!.map((x) => x.toJson())),
        "google_meet": List<dynamic>.from(googleMeet!.map((x) => x.toJson())),
        "jitsi_meeting":
            List<dynamic>.from(jitsiMeeting!.map((x) => x.toJson())),
      };
}

class Announcement {
  Announcement({
    this.id,
    this.user,
    this.courseId,
    this.detail,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? user;
  String? courseId;
  String? detail;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Announcement.fromJson(Map<String, dynamic> json) => Announcement(
        id: json["id"],
        user: json["user"],
        courseId: json["course_id"],
        detail: json["detail"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "course_id": courseId,
        "detail": detail,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Assignment {
  Assignment({
    this.id,
    this.user,
    this.courseId,
    this.instructor,
    this.chapterId,
    this.title,
    this.assignment,
    this.assignmentPath,
    this.type,
    this.detail,
    this.rating,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? user;
  String? courseId;
  String? instructor;
  String? chapterId;
  String? title;
  String? assignment;
  String? assignmentPath;
  dynamic type;
  String? detail;
  dynamic rating;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
        id: json["id"],
        user: json["user"],
        courseId: json["course_id"],
        instructor: json["instructor"],
        chapterId: json["chapter_id"],
        title: json["title"],
        assignment: json["assignment"],
        assignmentPath: json["assignment_path"],
        type: json["type"],
        detail: json["detail"],
        rating: json["rating"] == null ? null : json["rating"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "course_id": courseId,
        "instructor": instructor,
        "chapter_id": chapterId,
        "title": title,
        "assignment": assignment,
        "assignment_path": assignmentPath,
        "type": type,
        "detail": detail,
        "rating": rating == null ? null : rating,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Overview {
  Overview({
    this.courseTitle,
    this.shortDetail,
    this.detail,
    this.instructor,
    this.instructorEmail,
    this.instructorDetail,
    this.userEnrolled,
    this.classes,
  });

  String? courseTitle;
  String? shortDetail;
  String? detail;
  String? instructor;
  String? instructorEmail;
  String? instructorDetail;
  int? userEnrolled;
  int? classes;

  factory Overview.fromJson(Map<String, dynamic> json) => Overview(
        courseTitle: json["course_title"],
        shortDetail: json["short_detail"],
        detail: json["detail"],
        instructor: json["instructor"],
        instructorEmail: json["instructor_email"],
        instructorDetail: json["instructor_detail"],
        userEnrolled: json["user_enrolled"],
        classes: json["classes"],
      );

  Map<String, dynamic> toJson() => {
        "course_title": courseTitle,
        "short_detail": shortDetail,
        "detail": detail,
        "instructor": instructor,
        "instructor_email": instructorEmail,
        "instructor_detail": instructorDetail,
        "user_enrolled": userEnrolled,
        "classes": classes,
      };
}

class ContentModelQuestion {
  ContentModelQuestion({
    this.id,
    this.user,
    this.instructor,
    this.image,
    this.imagepath,
    this.course,
    this.title,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.answer,
  });

  int? id;
  String? user;
  String? instructor;
  String? image;
  String? imagepath;
  String? course;
  String? title;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<Answer>? answer;

  factory ContentModelQuestion.fromJson(Map<String, dynamic> json) =>
      ContentModelQuestion(
        id: json["id"],
        user: json["user"],
        instructor: json["instructor"],
        image: json["image"],
        imagepath: json["imagepath"],
        course: json["course"],
        title: json["title"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        answer:
            List<Answer>.from(json["answer"].map((x) => Answer.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "instructor": instructor,
        "image": image,
        "imagepath": imagepath,
        "course": course,
        "title": title,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "answer": List<dynamic>.from(answer!.map((x) => x.toJson())),
      };
}

class Answer {
  Answer({
    this.course,
    this.user,
    this.instructor,
    this.image,
    this.imagepath,
    this.question,
    this.answer,
    this.status,
  });

  String? course;
  String? user;
  String? instructor;
  String? image;
  String? imagepath;
  String? question;
  String? answer;
  dynamic status;

  factory Answer.fromJson(Map<String, dynamic> json) => Answer(
        course: json["course"],
        user: json["user"],
        instructor: json["instructor"],
        image: json["image"],
        imagepath: json["imagepath"],
        question: json["question"],
        answer: json["answer"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "course": course,
        "user": user,
        "instructor": instructor,
        "image": image,
        "imagepath": imagepath,
        "question": question,
        "answer": answer,
        "status": status,
      };
}

class Quiz {
  Quiz({
    this.id,
    this.courseId,
    this.course,
    this.title,
    this.description,
    this.perQuestionMark,
    this.status,
    this.quizAgain,
    this.dueDays,
    this.type,
    this.createdBy,
    this.updatedBy,
    this.questions,
  });

  int? id;
  int? courseId;
  String? course;
  String? title;
  String? description;
  String? perQuestionMark;
  String? status;
  String? quizAgain;
  String? dueDays;
  String? type;
  DateTime? createdBy;
  DateTime? updatedBy;
  List<QuizQuestion>? questions;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json["id"],
        courseId: json["course_id"],
        course: json["course"],
        title: json["title"],
        description: json["description"],
        perQuestionMark: json["per_question_mark"].toString(),
        status: json["status"].toString(),
        quizAgain: json["quiz_again"].toString(),
        dueDays: json["due_days"].toString(),
        type: json["type"].toString(),
        createdBy: DateTime.parse(json["created_by"]),
        updatedBy: DateTime.parse(json["updated_by"]),
        questions: List<QuizQuestion>.from(
            json["questions"].map((x) => QuizQuestion.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "course": course,
        "title": title,
        "description": description,
        "per_question_mark": perQuestionMark,
        "status": status,
        "quiz_again": quizAgain,
        "due_days": dueDays,
        "type": type,
        "created_by": createdBy!.toIso8601String(),
        "updated_by": updatedBy!.toIso8601String(),
        "questions": List<dynamic>.from(questions!.map((x) => x.toJson())),
      };
}

class QuizQuestion {
  QuizQuestion(
      {this.id,
      this.course,
      this.topic,
      this.question,
      this.status,
      this.correct,
      this.incorrectAnswers,
      this.allAnswers});

  int? id;
  String? course;
  String? topic;
  String? question;
  String? status;
  String? correct;
  List<String>? incorrectAnswers;
  Map<String, String>? allAnswers;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
        id: json["id"],
        course: json["course"],
        topic: json["topic"],
        question: json["question"],
        status: json["status"],
        correct: json["correct"],
        incorrectAnswers: json["incorrect_answers"] != null
            ? List<String>.from(json["incorrect_answers"].map((x) => x))
            : [],
        allAnswers: json.containsKey("all_answers")
            ? Map<String, String>.from(json["all_answers"])
            : {},
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course": course,
        "topic": topic,
        "question": question,
        "status": status,
        "correct": correct,
        "incorrect_answers":
            List<dynamic>.from(incorrectAnswers!.map((x) => x)),
        "all_answers":
            Map<String, String>.from(allAnswers!.cast<String, String>()),
      };

  QuizQuestion.fromMap(Map<String, dynamic> data)
      : course = data["course"],
        topic = "topic",
        question = data["question"],
        correct = data["correct"],
        incorrectAnswers = data["incorrect_answers"];

  static List<QuizQuestion> fromData(List<Map<String, dynamic>> data) {
    return data.map((question) => QuizQuestion.fromMap(question)).toList();
  }
}

class Appointment {
  Appointment({
    this.id,
    this.user,
    this.courseId,
    this.instructor,
    this.title,
    this.detail,
    this.accept,
    this.reply,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? user;
  String? courseId;
  String? instructor;
  String? title;
  String? detail;
  dynamic accept;
  String? reply;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Appointment.fromJson(Map<String, dynamic> json) => Appointment(
        id: json["id"],
        user: json["user"],
        courseId: json["course_id"],
        instructor: json["instructor"],
        title: json["title"],
        detail: json["detail"],
        accept: json["accept"],
        reply: json["reply"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "course_id": courseId,
        "instructor": instructor,
        "title": title,
        "detail": detail,
        "accept": accept,
        "reply": reply,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Papers {
  int? id;
  String? course;
  String? title;
  String? file;
  String? filepath;
  String? detail;
  String? status;
  String? createdAt;
  String? updatedAt;

  Papers(
      {this.id,
      this.course,
      this.title,
      this.file,
      this.filepath,
      this.detail,
      this.status,
      this.createdAt,
      this.updatedAt});

  Papers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    course = json['course'];
    title = json['title'];
    file = json['file'];
    filepath = json['filepath'];
    detail = json['detail'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['course'] = this.course;
    data['title'] = this.title;
    data['file'] = this.file;
    data['filepath'] = this.filepath;
    data['detail'] = this.detail;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class GoogleMeet {
  dynamic id;
  dynamic meetingId;
  dynamic userId;
  dynamic ownerId;
  dynamic meetingTitle;
  dynamic startTime;
  dynamic endTime;
  dynamic duration;
  dynamic meetUrl;
  dynamic linkBy;
  dynamic courseId;
  dynamic createdAt;
  dynamic updatedAt;
  dynamic type;
  dynamic agenda;
  dynamic image;
  dynamic timezone;

  GoogleMeet(
      {this.id,
      this.meetingId,
      this.userId,
      this.ownerId,
      this.meetingTitle,
      this.startTime,
      this.endTime,
      this.duration,
      this.meetUrl,
      this.linkBy,
      this.courseId,
      this.createdAt,
      this.updatedAt,
      this.type,
      this.agenda,
      this.image,
      this.timezone});

  GoogleMeet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    meetingId = json['meeting_id'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    meetingTitle = json['meeting_title'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    meetUrl = json['meet_url'];
    linkBy = json['link_by'];
    courseId = json['course_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    type = json['type'];
    agenda = json['agenda'];
    image = json['image'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['meeting_id'] = this.meetingId;
    data['user_id'] = this.userId;
    data['owner_id'] = this.ownerId;
    data['meeting_title'] = this.meetingTitle;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['meet_url'] = this.meetUrl;
    data['link_by'] = this.linkBy;
    data['course_id'] = this.courseId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['type'] = this.type;
    data['agenda'] = this.agenda;
    data['image'] = this.image;
    data['timezone'] = this.timezone;
    return data;
  }
}

class JitsiMeeting {
  dynamic id;
  dynamic userId;
  dynamic ownerId;
  dynamic meetingId;
  dynamic meetingTitle;
  dynamic startTime;
  dynamic endTime;
  dynamic duration;
  dynamic jitsiUrl;
  dynamic linkBy;
  dynamic courseId;
  dynamic timeZone;
  dynamic type;
  dynamic agenda;
  dynamic image;
  dynamic createdAt;
  dynamic updatedAt;

  JitsiMeeting(
      {this.id,
      this.userId,
      this.ownerId,
      this.meetingId,
      this.meetingTitle,
      this.startTime,
      this.endTime,
      this.duration,
      this.jitsiUrl,
      this.linkBy,
      this.courseId,
      this.timeZone,
      this.type,
      this.agenda,
      this.image,
      this.createdAt,
      this.updatedAt});

  JitsiMeeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    ownerId = json['owner_id'];
    meetingId = json['meeting_id'];
    meetingTitle = json['meeting_title'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    duration = json['duration'];
    jitsiUrl = json['jitsi_url'];
    linkBy = json['link_by'];
    courseId = json['course_id'];
    timeZone = json['time_zone'];
    type = json['type'];
    agenda = json['agenda'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['owner_id'] = this.ownerId;
    data['meeting_id'] = this.meetingId;
    data['meeting_title'] = this.meetingTitle;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['duration'] = this.duration;
    data['jitsi_url'] = this.jitsiUrl;
    data['link_by'] = this.linkBy;
    data['course_id'] = this.courseId;
    data['time_zone'] = this.timeZone;
    data['type'] = this.type;
    data['agenda'] = this.agenda;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
