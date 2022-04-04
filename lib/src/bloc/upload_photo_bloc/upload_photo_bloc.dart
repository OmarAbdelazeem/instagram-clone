import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

import '../../core/utils/image_utils.dart';
import '../../repository/data_repository.dart';
import '../../repository/storage_repository.dart';

part 'upload_photo_event.dart';

part 'upload_photo_state.dart';

class UploadPhotoBloc extends Bloc<UploadPhotoEvent, UploadPhotoState> {
  final DataRepository dataRepository;
  final StorageRepository storageRepository;

  UploadPhotoBloc(
      {required this.dataRepository, required this.storageRepository})
      : super(UploadPhotoInitial()) {
    on<PickProfilePhotoStarted>(_onPickingProfilePhotoTapped);
  }

  void _onPickingProfilePhotoTapped(
      PickProfilePhotoStarted event, Emitter<UploadPhotoState> emit) async {
    //Todo try to transfer this function to another bloc
    try {
      emit(UploadPhotoLoading());
      final imageFile = await ImageUtils.pickImage(event.imageSource);
      if (imageFile != null) {
        final photoUrl = await storageRepository.uploadProfilePhoto(
            selectedFile: imageFile, userId: event.userId);
        await dataRepository.addProfilePhoto(event.userId, photoUrl);
        emit(ProfilePhotoAdded(photoUrl));
      }
    } catch (e) {
      print(e.toString());
      emit(Error(e.toString()));
    }
  }
}
