import 'package:get/get.dart';
import 'package:studentjo/models/answer_student_model.dart';
import 'package:studentjo/models/question_teacher_model.dart';
import 'package:studentjo/models/user_model.dart';
import 'package:studentjo/models/video_model.dart';

class AppController extends GetxController {
  RxInt indexBody = 0.obs;

  RxList<String> urlThumnals = <String>[].obs;

  RxList<UserModel> currentUserModels = <UserModel>[].obs;

  RxList<UserModel> teacherUserModels = <UserModel>[].obs;

  RxList<UserModel> studentUserModels = <UserModel>[].obs;

  RxList<VideoModel> videoModels = <VideoModel>[].obs;

  RxList<String> docIdVideos = <String>[].obs;

  RxList<String?> chooseTypeAnswers = <String?>[null].obs;

  RxList<bool?> yesNoAnswers = <bool?>[null].obs;

  RxList<QuestionTeacherModel> qurestionTescherModels =
      <QuestionTeacherModel>[].obs;

  RxList<String> docIdQuestions = <String>[].obs;

  RxList<List<AnswerStudentModel>> listAnswerStudentModels =
      <List<AnswerStudentModel>>[].obs;

  RxList<AnswerStudentModel> listAnswerStudentMobileModels =
      <AnswerStudentModel>[].obs;

  RxBool displayAfterSend = false.obs;

  RxBool displayStop = false.obs;

  RxBool displaySumAnswer = false.obs;

  RxString showAnswer = ''.obs;
  RxString showWeight = ''.obs;
}
