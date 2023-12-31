import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dustudylink/controller/bucket_controller.dart';
import 'package:dustudylink/controller/resource_controller.dart';
import 'package:dustudylink/model/bucket.dart';
import 'package:dustudylink/model/resource.dart';
import 'package:dustudylink/view/component/resource_form.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:dustudylink/theme/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

final ResourceController resourceController = ResourceController();
final BucketController bucketController = BucketController();

class ResourceCard extends StatelessWidget {
  final Resource resource;
  final bool isBucketResource;
  final Bucket? bucket;
  final ResourceController resourceController = ResourceController();
  final BucketController bucketController = BucketController();

  ResourceCard(
      {Key? key,
      required this.resource,
      this.isBucketResource = false,
      this.bucket})
      : super(key: key) {
    assert(!isBucketResource && bucket == null ||
        isBucketResource && bucket != null);
  }

  ImageProvider<Object> fetchImage(imageURL) {
    var noImg = AssetImage('assets/no_img7.png');
    if (imageURL != null) {
      try {
        // return CachedNetworkImageProvider(
        //     'https://web-production-ef94.up.railway.app/${resource.imageUrl!}',
        //     imageRenderMethodForWeb: ImageRenderMethodForWeb.HttpGet);
        return NetworkImage(
            'https://web-production-ef94.up.railway.app/' + imageURL);
      } catch (e) {
        return noImg;
      }
    }
    return noImg;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).cardColor.withOpacity(0.2),
            blurRadius: 10,
          ),
        ],
      ),
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius)),
        shadowColor: Colors.transparent,
        color: Theme.of(context).cardColor,
        child: InkWell(
          onTap: () => resourceController.launchURL(resource.url),
          onLongPress: () => showModalBottomSheet<void>(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        onTap: () {
                          copyLink(context);
                          Navigator.of(context).pop();
                        },
                        leading: Icon(
                          FeatherIcons.copy,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        title: Text(
                          'Copy Link',
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                    ListTile(
                        onTap: () => showResourceForm(
                              context: context,
                              isEdit: true,
                              resource: resource,
                              isBucketResource: isBucketResource,
                              bucket: bucket,
                            ),
                        leading: Icon(
                          FeatherIcons.edit3,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        title: Text(
                          'Edit Resource',
                          style: Theme.of(context).textTheme.bodyText1,
                        )),
                    ListTile(
                        onTap: () async {
                          showDeleteAlert(context);
                        },
                        leading: const Icon(
                          FeatherIcons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          'Delete Resource',
                          style: Theme.of(context).textTheme.bodyText1?.apply(
                                color: Colors.red,
                              ),
                        )),
                  ],
                ),
              );
            },
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Stack(children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(cardRadius)),
                  child: AspectRatio(
                    aspectRatio: 1200 / 627,
                    child: FadeInImage(
                      placeholder: MemoryImage(kTransparentImage),
                      image: fetchImage(resource.imageUrl),
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset('assets/no_img7.png',
                            fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 7.5, vertical: 5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).cardColor,
                    ),
                    child: Text(resource.category,
                        style: Theme.of(context).textTheme.bodyText1),
                  ),
                ),
              ]),
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 12.0, 20.0, 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 4.0),
                      margin: const EdgeInsets.all(1.0),
                      child: IconButton(
                        onPressed: () {
                          copyLink(context);
                        },
                        icon: const Icon(FeatherIcons.copy),
                        color: Theme.of(context).textTheme.bodyText1?.color,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(resource.title,
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(resource.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyText1),
                          ),
                          Text(resource.domain,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .domainText
                                  .apply(
                                      color: Theme.of(context).disabledColor)),
                          const SizedBox(
                            height: 5.0,
                          ),
                          RatingBar.builder(
                            initialRating: resource.rating,
                            unratedColor: Theme.of(context).focusColor,
                            minRating: 0.0,
                            direction: Axis.horizontal,
                            allowHalfRating: false,
                            itemSize: 20,
                            itemCount: 5,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 1.0),
                            itemBuilder: (context, index) => Icon(
                              Icons.star,
                              color: Theme.of(context).primaryColor,
                            ),
                            onRatingUpdate: (rating) async {
                              if (isBucketResource) {
                                resource.changeRating(rating);
                                if (bucket != null) {
                                  bucketController.editBucketResourceForOneUser(
                                      bucket!, resource);
                                }
                                List ratingInfo = await findRating(
                                    isBucketResource, resource, bucket);
                                rating = ratingInfo[0];
                              } else {
                                resource.changeRating(rating);
                                resourceController.editResource(resource);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FutureBuilder<List>(
                          future:
                              findRating(isBucketResource, resource, bucket),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return isBucketResource
                                  ? Column(
                                      children: [
                                        Text(
                                          snapshot.data![0].toStringAsFixed(1),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              FeatherIcons.user,
                                              size: 14.0,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1
                                                  ?.color,
                                            ),
                                            const SizedBox(
                                              width: 3.0,
                                            ),
                                            Text(
                                              snapshot.data![1].toString(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  : const SizedBox.shrink();
                            } else if (snapshot.hasError) {
                              // TODO: Error handling
                              return Text('${snapshot.error}');
                            } else {
                              // TODO: Progress indicator
                              return SpinKitFadingFour(
                                  size: 25.0,
                                  color: Theme.of(context).primaryColor);
                            }
                          }),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List> findRating(
      bool isBucketResource, Resource resource, Bucket? bucket) async {
    if (isBucketResource && bucket != null) {
      List ratingInfo;
      ratingInfo =
          await bucketController.findAverageResourceRating(bucket, resource);
      return ratingInfo;
    } else {
      return [resource.rating, resource.userCount];
    }
  }

  void copyLink(BuildContext context) {
    resourceController.copyResourceURL(resource);
    showDUStudyLinkToast(context, 'Link copied to the clipboard!');
  }

  Future<Object?> showDeleteAlert(BuildContext context) async {
    return await showBlurredDialog(
        context: context,
        dialogBody: AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          shape: dialogShape,
          actions: <Widget>[
            TextButton(
                onPressed: () async {
                  !isBucketResource
                      ? resourceController.deleteResource(resource)
                      : bucketController.deleteBucketResource(
                          bucket!, resource);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Yes'.toUpperCase(),
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                )),
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'No'.toUpperCase(),
                  style: Theme.of(context).textTheme.buttonText.fixFontFamily(),
                )),
          ],
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Delete'.toUpperCase(),
                style: Theme.of(context).textTheme.formLabel.fixFontFamily(),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Are you sure that you want to delete this resource?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ],
          ),
        ));
  }
}
