import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:knowme/models/post_model.dart';

class ProfileController extends GetxController {
  List<PostModel> poststList = [
    PostModel(
        id: '312312',
        description:
            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using',
        src:
            'https://mir-s3-cdn-cf.behance.net/project_modules/1400/e8016499129199.5eeba118dc7a0.jpg',
        postType: PostType.Image),
    PostModel(
        id: '312312',
        description:
            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using',
        src:
            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ3a29V3GkPf7mpW3vWdbhKmpo3b67K7mUBOQ&usqp=CAU',
        postType: PostType.Image),
    PostModel(
        id: '312312',
        description:
            'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using',
        src: 'https://definicao.net/wp-content/uploads/2019/04/selfie-3.jpg',
        postType: PostType.Image),
  ];
}
