import 'package:knowme/models/user_model.dart';

final CURRENT_USER = UserModel(
    id: '5sd4f',
    profileImage:
        'https://image.shutterstock.com/image-photo/profile-picture-smiling-millennial-asian-260nw-1836020740.jpg',
    bio:
        'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s,',
    completName: 'Joana da Silva Ferreira',
    profileName: 'joana98',
    uf: 'SP',
    city: 'São Paulo',
    lat: '5646442364.62',
    lng: '5344623542342.65',
    followMe: [],
    follow: [],
    createdAt: DateTime.now(),
    email: 'felnanuke@gmail.com',
    state: AccountState.ACTIVE,
    updatedAt: DateTime.now(),
    receivedInteractions: [],
    postsList: [],
    sendIteractions: [],
    sex: Sex.FEMALE,
    contacts: UserContactsModel(),
    emailConfirm: false);
