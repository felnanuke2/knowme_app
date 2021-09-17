import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import 'package:knowme/models/user_model.dart';

class ExploringSugestionTile extends StatelessWidget {
  const ExploringSugestionTile({
    Key? key,
    required this.itemUser,
  }) : super(key: key);
  final UserModel itemUser;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.back(result: itemUser),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 0,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              leading: Container(
                width: 60,
                height: 60,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: itemUser.profileImage ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Icon(Icons.person),
                  ),
                ),
              ),
              title: Text(itemUser.completName ?? ''),
              subtitle: Text((itemUser.profileName ?? '') + '#',
                  style: TextStyle(color: Colors.black.withOpacity(0.4))),
            ),
          ),
        ),
      ),
    );
  }
}
