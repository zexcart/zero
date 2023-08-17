import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/components/post_comments_reply_widget.dart';
import '/components/post_reply_comment_input_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_toggle_icon.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/pages/posts/comment_menu/comment_menu_widget.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'post_comments_model.dart';
export 'post_comments_model.dart';

class PostCommentsWidget extends StatefulWidget {
  const PostCommentsWidget({
    Key? key,
    required this.postRef,
  }) : super(key: key);

  final DocumentReference? postRef;

  @override
  _PostCommentsWidgetState createState() => _PostCommentsWidgetState();
}

class _PostCommentsWidgetState extends State<PostCommentsWidget> {
  late PostCommentsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PostCommentsModel());

    logFirebaseEvent('screen_view',
        parameters: {'screen_name': 'postComments'});
    _model.commentController ??= TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return FutureBuilder<PostsRecord>(
      future: PostsRecord.getDocumentOnce(widget.postRef!),
      builder: (context, snapshot) {
        // Customize what your widget looks like when it's loading.
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: FlutterFlowTheme.of(context).black600,
            body: Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ),
          );
        }
        final postCommentsPostsRecord = snapshot.data!;
        return Title(
            title: 'postComments',
            color: FlutterFlowTheme.of(context).primary.withAlpha(0XFF),
            child: GestureDetector(
              onTap: () =>
                  FocusScope.of(context).requestFocus(_model.unfocusNode),
              child: Scaffold(
                key: scaffoldKey,
                backgroundColor: FlutterFlowTheme.of(context).black600,
                appBar: AppBar(
                  backgroundColor:
                      FlutterFlowTheme.of(context).secondaryBackground,
                  automaticallyImplyLeading: false,
                  leading: FlutterFlowIconButton(
                    borderColor: Colors.transparent,
                    borderRadius: 30.0,
                    borderWidth: 1.0,
                    buttonSize: 60.0,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 30.0,
                    ),
                    onPressed: () async {
                      logFirebaseEvent(
                          'POST_COMMENTS_arrow_back_rounded_ICN_ON_');
                      logFirebaseEvent('IconButton_navigate_back');
                      context.safePop();
                    },
                  ),
                  title: Text(
                    'Comments',
                    style: FlutterFlowTheme.of(context).headlineMedium.override(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 22.0,
                        ),
                  ),
                  actions: [],
                  centerTitle: false,
                  elevation: 2.0,
                ),
                body: SafeArea(
                  top: true,
                  child: FutureBuilder<UsersRecord>(
                    future: UsersRecord.getDocumentOnce(
                        postCommentsPostsRecord.postUser!),
                    builder: (context, snapshot) {
                      // Customize what your widget looks like when it's loading.
                      if (!snapshot.hasData) {
                        return Center(
                          child: SizedBox(
                            width: 20.0,
                            height: 20.0,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                FlutterFlowTheme.of(context).primary,
                              ),
                            ),
                          ),
                        );
                      }
                      final containerUsersRecord = snapshot.data!;
                      return Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 20.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            8.0, 8.0, 8.0, 100.0),
                                        child: PagedListView<
                                            DocumentSnapshot<Object?>?,
                                            PostCommentsRecord>(
                                          pagingController:
                                              _model.setListViewController(
                                                  PostCommentsRecord
                                                          .collection()
                                                      .orderBy('total_likes',
                                                          descending: true)
                                                      .orderBy('replyCounts',
                                                          descending: true)
                                                      .orderBy('comment_time',
                                                          descending: true),
                                                  parent: widget.postRef),
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          reverse: false,
                                          scrollDirection: Axis.vertical,
                                          builderDelegate:
                                              PagedChildBuilderDelegate<
                                                  PostCommentsRecord>(
                                            // Customize what your widget looks like when it's loading the first page.
                                            firstPageProgressIndicatorBuilder:
                                                (_) => Center(
                                              child: SizedBox(
                                                width: 40.0,
                                                height: 40.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Customize what your widget looks like when it's loading another page.
                                            newPageProgressIndicatorBuilder:
                                                (_) => Center(
                                              child: SizedBox(
                                                width: 40.0,
                                                height: 40.0,
                                                child:
                                                    CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                  ),
                                                ),
                                              ),
                                            ),

                                            itemBuilder:
                                                (context, _, listViewIndex) {
                                              final listViewPostCommentsRecord =
                                                  _model
                                                      .listViewPagingController!
                                                      .itemList![listViewIndex];
                                              return Container(
                                                width: 100.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 0.0, 0.0, 12.0),
                                                  child: StreamBuilder<
                                                      UsersRecord>(
                                                    stream: UsersRecord.getDocument(
                                                        listViewPostCommentsRecord
                                                            .commentUser!),
                                                    builder:
                                                        (context, snapshot) {
                                                      // Customize what your widget looks like when it's loading.
                                                      if (!snapshot.hasData) {
                                                        return Center(
                                                          child: SizedBox(
                                                            width: 40.0,
                                                            height: 40.0,
                                                            child:
                                                                CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                      Color>(
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryBackground,
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                      final rowUsersRecord =
                                                          snapshot.data!;
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onLongPress: () async {
                                                          logFirebaseEvent(
                                                              'POST_COMMENTS_Row_bottt0ez_ON_LONG_PRESS');
                                                          if ((rowUsersRecord
                                                                      .uid ==
                                                                  currentUserUid) ||
                                                              (postCommentsPostsRecord
                                                                      .uid ==
                                                                  currentUserUid)) {
                                                            logFirebaseEvent(
                                                                'Row_bottom_sheet');
                                                            await showModalBottomSheet(
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors.white,
                                                              enableDrag: false,
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return GestureDetector(
                                                                  onTap: () => FocusScope.of(
                                                                          context)
                                                                      .requestFocus(
                                                                          _model
                                                                              .unfocusNode),
                                                                  child:
                                                                      Padding(
                                                                    padding: MediaQuery
                                                                        .viewInsetsOf(
                                                                            context),
                                                                    child:
                                                                        CommentMenuWidget(
                                                                      commentRef:
                                                                          listViewPostCommentsRecord
                                                                              .reference,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ).then((value) =>
                                                                setState(
                                                                    () {}));
                                                          } else {
                                                            return;
                                                          }
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: 42.0,
                                                                              height: 42.0,
                                                                              decoration: BoxDecoration(
                                                                                color: FlutterFlowTheme.of(context).secondaryBackground,
                                                                                shape: BoxShape.circle,
                                                                                border: Border.all(
                                                                                  color: FlutterFlowTheme.of(context).secondaryText,
                                                                                ),
                                                                              ),
                                                                              child: InkWell(
                                                                                splashColor: Colors.transparent,
                                                                                focusColor: Colors.transparent,
                                                                                hoverColor: Colors.transparent,
                                                                                highlightColor: Colors.transparent,
                                                                                onTap: () async {
                                                                                  logFirebaseEvent('POST_COMMENTS_CircleImage_pkt1tuu0_ON_TA');
                                                                                  logFirebaseEvent('CircleImage_navigate_to');

                                                                                  context.pushNamed(
                                                                                    'profile',
                                                                                    queryParameters: {
                                                                                      'userDetails': serializeParam(
                                                                                        rowUsersRecord.reference,
                                                                                        ParamType.DocumentReference,
                                                                                      ),
                                                                                    }.withoutNulls,
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  width: 40.0,
                                                                                  height: 40.0,
                                                                                  clipBehavior: Clip.antiAlias,
                                                                                  decoration: BoxDecoration(
                                                                                    shape: BoxShape.circle,
                                                                                  ),
                                                                                  child: Image.network(
                                                                                    rowUsersRecord.photoUrl,
                                                                                    fit: BoxFit.cover,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 0.0, 0.0),
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      InkWell(
                                                                                        splashColor: Colors.transparent,
                                                                                        focusColor: Colors.transparent,
                                                                                        hoverColor: Colors.transparent,
                                                                                        highlightColor: Colors.transparent,
                                                                                        onTap: () async {
                                                                                          logFirebaseEvent('POST_COMMENTS_PAGE_Text_4vingah3_ON_TAP');
                                                                                          logFirebaseEvent('Text_navigate_to');

                                                                                          context.pushNamed(
                                                                                            'profile',
                                                                                            queryParameters: {
                                                                                              'userDetails': serializeParam(
                                                                                                rowUsersRecord.reference,
                                                                                                ParamType.DocumentReference,
                                                                                              ),
                                                                                            }.withoutNulls,
                                                                                          );
                                                                                        },
                                                                                        child: Text(
                                                                                          rowUsersRecord.username.maybeHandleOverflow(maxChars: 18),
                                                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                                fontFamily: 'Poppins',
                                                                                                fontSize: 14.0,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        children: [
                                                                                          if (rowUsersRecord.isPremiumUser)
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                                              child: Icon(
                                                                                                Icons.stars,
                                                                                                color: FlutterFlowTheme.of(context).warning,
                                                                                                size: 16.0,
                                                                                              ),
                                                                                            ),
                                                                                          if (rowUsersRecord.userHasGoldentick || rowUsersRecord.userHasBluetick)
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(2.0, 0.0, 0.0, 0.0),
                                                                                              child: Icon(
                                                                                                Icons.verified,
                                                                                                color: rowUsersRecord.userHasGoldentick ? FlutterFlowTheme.of(context).warning : FlutterFlowTheme.of(context).primary,
                                                                                                size: 16.0,
                                                                                              ),
                                                                                            ),
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0.0, 2.0, 0.0, 0.0),
                                                                                    child: Text(
                                                                                      listViewPostCommentsRecord.commentText,
                                                                                      textAlign: TextAlign.start,
                                                                                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                            fontFamily: 'Poppins',
                                                                                            color: FlutterFlowTheme.of(context).secondaryText,
                                                                                            fontSize: 12.0,
                                                                                          ),
                                                                                    ),
                                                                                  ),
                                                                                  Row(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(0.0, 1.0, 0.0, 0.0),
                                                                                        child: Text(
                                                                                          dateTimeFormat(
                                                                                            'relative',
                                                                                            listViewPostCommentsRecord.commentTime!,
                                                                                            locale: FFLocalizations.of(context).languageCode,
                                                                                          ),
                                                                                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                fontFamily: 'Poppins',
                                                                                                fontSize: 10.0,
                                                                                              ),
                                                                                        ),
                                                                                      ),
                                                                                      Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(10.0, 1.0, 0.0, 0.0),
                                                                                        child: InkWell(
                                                                                          splashColor: Colors.transparent,
                                                                                          focusColor: Colors.transparent,
                                                                                          hoverColor: Colors.transparent,
                                                                                          highlightColor: Colors.transparent,
                                                                                          onTap: () async {
                                                                                            logFirebaseEvent('POST_COMMENTS_PAGE_Text_aiy7iv3a_ON_TAP');
                                                                                            logFirebaseEvent('Text_bottom_sheet');
                                                                                            await showModalBottomSheet(
                                                                                              isScrollControlled: true,
                                                                                              backgroundColor: Colors.transparent,
                                                                                              enableDrag: false,
                                                                                              context: context,
                                                                                              builder: (context) {
                                                                                                return GestureDetector(
                                                                                                  onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                                                                                                  child: Padding(
                                                                                                    padding: MediaQuery.viewInsetsOf(context),
                                                                                                    child: PostReplyCommentInputWidget(
                                                                                                      postRef: widget.postRef,
                                                                                                      postCommentRef: listViewPostCommentsRecord.reference,
                                                                                                      postCommentUser: listViewPostCommentsRecord.commentUser,
                                                                                                      repliedTo: listViewPostCommentsRecord.commentUser,
                                                                                                    ),
                                                                                                  ),
                                                                                                );
                                                                                              },
                                                                                            ).then((value) => setState(() {}));
                                                                                          },
                                                                                          child: Text(
                                                                                            'Reply',
                                                                                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                                                                                  fontFamily: 'Poppins',
                                                                                                  fontSize: 10.0,
                                                                                                ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: EdgeInsetsDirectional.fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            ToggleIcon(
                                                                              onPressed: () async {
                                                                                final likesElement = currentUserReference;
                                                                                final likesUpdate = listViewPostCommentsRecord.likes.contains(likesElement)
                                                                                    ? FieldValue.arrayRemove([
                                                                                        likesElement
                                                                                      ])
                                                                                    : FieldValue.arrayUnion([
                                                                                        likesElement
                                                                                      ]);
                                                                                await listViewPostCommentsRecord.reference.update({
                                                                                  'likes': likesUpdate,
                                                                                });
                                                                                logFirebaseEvent('POST_COMMENTS_ToggleIcon_g5xwkzkh_ON_TOG');
                                                                                final firestoreBatch = FirebaseFirestore.instance.batch();
                                                                                try {
                                                                                  logFirebaseEvent('ToggleIcon_backend_call');

                                                                                  firestoreBatch.update(listViewPostCommentsRecord.reference, {
                                                                                    'likes': FieldValue.arrayUnion([
                                                                                      currentUserReference
                                                                                    ]),
                                                                                  });
                                                                                  if (listViewPostCommentsRecord.likes.contains(currentUserReference)) {
                                                                                    logFirebaseEvent('ToggleIcon_wait__delay');
                                                                                    await Future.delayed(const Duration(milliseconds: 500));
                                                                                    logFirebaseEvent('ToggleIcon_backend_call');

                                                                                    firestoreBatch.update(listViewPostCommentsRecord.reference, {
                                                                                      'likes': FieldValue.arrayRemove([
                                                                                        currentUserReference
                                                                                      ]),
                                                                                    });
                                                                                  } else {
                                                                                    logFirebaseEvent('ToggleIcon_backend_call');

                                                                                    firestoreBatch.update(listViewPostCommentsRecord.reference, {
                                                                                      'likes': FieldValue.arrayUnion([
                                                                                        currentUserReference
                                                                                      ]),
                                                                                    });
                                                                                  }
                                                                                } finally {
                                                                                  await firestoreBatch.commit();
                                                                                }
                                                                              },
                                                                              value: listViewPostCommentsRecord.likes.contains(currentUserReference),
                                                                              onIcon: Icon(
                                                                                Icons.favorite_rounded,
                                                                                color: Color(0xFFFB0E0E),
                                                                                size: 20.0,
                                                                              ),
                                                                              offIcon: Icon(
                                                                                Icons.favorite_border,
                                                                                color: FlutterFlowTheme.of(context).primaryBtnText,
                                                                                size: 20.0,
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(3.0, 0.0, 0.0, 0.0),
                                                                              child: Text(
                                                                                formatNumber(
                                                                                  listViewPostCommentsRecord.likes.length,
                                                                                  formatType: FormatType.compact,
                                                                                ),
                                                                                style: TextStyle(
                                                                                  fontSize: 10.0,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  if (listViewPostCommentsRecord
                                                                          .replyCounts >
                                                                      0)
                                                                    InkWell(
                                                                      splashColor:
                                                                          Colors
                                                                              .transparent,
                                                                      focusColor:
                                                                          Colors
                                                                              .transparent,
                                                                      hoverColor:
                                                                          Colors
                                                                              .transparent,
                                                                      highlightColor:
                                                                          Colors
                                                                              .transparent,
                                                                      onTap:
                                                                          () async {
                                                                        logFirebaseEvent(
                                                                            'POST_COMMENTS_PAGE_Text_e1ji78ce_ON_TAP');
                                                                        logFirebaseEvent(
                                                                            'Text_bottom_sheet');
                                                                        await showModalBottomSheet(
                                                                          isScrollControlled:
                                                                              true,
                                                                          backgroundColor:
                                                                              Colors.transparent,
                                                                          enableDrag:
                                                                              false,
                                                                          context:
                                                                              context,
                                                                          builder:
                                                                              (context) {
                                                                            return GestureDetector(
                                                                              onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
                                                                              child: Padding(
                                                                                padding: MediaQuery.viewInsetsOf(context),
                                                                                child: Container(
                                                                                  height: MediaQuery.sizeOf(context).height * 0.8,
                                                                                  child: PostCommentsReplyWidget(
                                                                                    postCommentRef: listViewPostCommentsRecord.reference,
                                                                                    postRef: widget.postRef,
                                                                                    postCommentUser: listViewPostCommentsRecord.commentUser,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ).then((value) =>
                                                                            setState(() {}));
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        'View ${listViewPostCommentsRecord.replyCounts.toString()}${listViewPostCommentsRecord.replyCounts == 1 ? 'reply' : ' replies'}',
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              fontFamily: 'Poppins',
                                                                              fontSize: 12.0,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional(0.0, 1.0),
                              child: Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 5.0, 0.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(0.0),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: 10.0,
                                      sigmaY: 10.0,
                                    ),
                                    child: Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          1.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(0.0),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          if (() {
                                            if (containerUsersRecord
                                                    .whoCanComment ==
                                                'anyone') {
                                              return postCommentsPostsRecord
                                                  .allowComments;
                                            } else if (containerUsersRecord
                                                    .whoCanComment ==
                                                'followers_i_follow_back') {
                                              return postCommentsPostsRecord
                                                  .allowComments;
                                            } else {
                                              return false;
                                            }
                                          }())
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      6.0, 10.0, 6.0, 10.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 0.0,
                                                                0.0, 1.0),
                                                    child: AuthUserStreamWidget(
                                                      builder: (context) =>
                                                          Container(
                                                        width: 40.0,
                                                        height: 40.0,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        child: Image.network(
                                                          valueOrDefault<
                                                              String>(
                                                            currentUserPhoto,
                                                            'https://upload.wikimedia.org/wikipedia/commons/a/ac/Default_pfp.jpg',
                                                          ),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  12.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      child: Stack(
                                                        alignment:
                                                            AlignmentDirectional(
                                                                1.0, 1.0),
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        0.0,
                                                                        0.0,
                                                                        5.0,
                                                                        0.0),
                                                            child:
                                                                AuthUserStreamWidget(
                                                              builder: (context) =>
                                                                  TextFormField(
                                                                controller: _model
                                                                    .commentController,
                                                                obscureText:
                                                                    false,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium,
                                                                  hintText:
                                                                      'Add a comment as ${valueOrDefault(currentUserDocument?.username, '')}...',
                                                                  hintStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .secondaryText,
                                                                        fontSize:
                                                                            14.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                      ),
                                                                  enabledBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  errorBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  focusedErrorBorder:
                                                                      InputBorder
                                                                          .none,
                                                                  contentPadding:
                                                                      EdgeInsetsDirectional.fromSTEB(
                                                                          16.0,
                                                                          16.0,
                                                                          16.0,
                                                                          16.0),
                                                                ),
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      fontFamily:
                                                                          'Poppins',
                                                                      fontSize:
                                                                          14.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      lineHeight:
                                                                          1.5,
                                                                    ),
                                                                maxLines: 5,
                                                                minLines: 1,
                                                                validator: _model
                                                                    .commentControllerValidator
                                                                    .asValidator(
                                                                        context),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  FFButtonWidget(
                                                    onPressed: () async {
                                                      logFirebaseEvent(
                                                          'POST_COMMENTS_PAGE_POST_BTN_ON_TAP');
                                                      var _shouldSetState =
                                                          false;
                                                      final firestoreBatch =
                                                          FirebaseFirestore
                                                              .instance
                                                              .batch();
                                                      try {
                                                        if (_model.commentController
                                                                    .text !=
                                                                null &&
                                                            _model.commentController
                                                                    .text !=
                                                                '') {
                                                          logFirebaseEvent(
                                                              'Button_backend_call');

                                                          var postCommentsRecordReference =
                                                              PostCommentsRecord
                                                                  .createDoc(widget
                                                                      .postRef!);
                                                          firestoreBatch.set(
                                                              postCommentsRecordReference,
                                                              {
                                                                ...createPostCommentsRecordData(
                                                                  commentText:
                                                                      _model
                                                                          .commentController
                                                                          .text,
                                                                  commentUser:
                                                                      currentUserReference,
                                                                  totalLikes: 0,
                                                                  replyCounts:
                                                                      0,
                                                                ),
                                                                'comment_time':
                                                                    FieldValue
                                                                        .serverTimestamp(),
                                                              });
                                                          _model.commentRef =
                                                              PostCommentsRecord
                                                                  .getDocumentFromData({
                                                            ...createPostCommentsRecordData(
                                                              commentText: _model
                                                                  .commentController
                                                                  .text,
                                                              commentUser:
                                                                  currentUserReference,
                                                              totalLikes: 0,
                                                              replyCounts: 0,
                                                            ),
                                                            'comment_time':
                                                                DateTime.now(),
                                                          }, postCommentsRecordReference);
                                                          _shouldSetState =
                                                              true;
                                                          logFirebaseEvent(
                                                              'Button_backend_call');

                                                          firestoreBatch.update(
                                                              widget.postRef!, {
                                                            'total_comments':
                                                                FieldValue
                                                                    .increment(
                                                                        1),
                                                          });
                                                          logFirebaseEvent(
                                                              'Button_clear_text_fields');
                                                          setState(() {
                                                            _model
                                                                .commentController
                                                                ?.clear();
                                                          });
                                                          logFirebaseEvent(
                                                              'Button_navigate_to');
                                                          if (Navigator.of(
                                                                  context)
                                                              .canPop()) {
                                                            context.pop();
                                                          }
                                                          context.pushNamed(
                                                            'postComments',
                                                            queryParameters: {
                                                              'postRef':
                                                                  serializeParam(
                                                                widget.postRef,
                                                                ParamType
                                                                    .DocumentReference,
                                                              ),
                                                            }.withoutNulls,
                                                          );

                                                          if (postCommentsPostsRecord
                                                                  .postUser !=
                                                              currentUserReference) {
                                                            logFirebaseEvent(
                                                                'Button_trigger_push_notification');
                                                            triggerPushNotification(
                                                              notificationTitle:
                                                                  'New Comment',
                                                              notificationText:
                                                                  '${functions.capitalizeString(currentUserDisplayName)} commented on your post!',
                                                              notificationSound:
                                                                  'default',
                                                              userRefs: [
                                                                postCommentsPostsRecord
                                                                    .postUser!
                                                              ],
                                                              initialPageName:
                                                                  'postComments',
                                                              parameterData: {
                                                                'postRef':
                                                                    postCommentsPostsRecord
                                                                        .reference,
                                                              },
                                                            );
                                                            logFirebaseEvent(
                                                                'Button_backend_call');

                                                            firestoreBatch.set(
                                                                NotificationsRecord
                                                                    .collection
                                                                    .doc(),
                                                                {
                                                                  ...createNotificationsRecordData(
                                                                    author: containerUsersRecord
                                                                        .reference,
                                                                    userRef:
                                                                        currentUserReference,
                                                                    postRef:
                                                                        postCommentsPostsRecord
                                                                            .reference,
                                                                    postCommentRef: _model
                                                                        .commentRef
                                                                        ?.reference,
                                                                    notificationType:
                                                                        'post_comment',
                                                                  ),
                                                                  'timestamp':
                                                                      FieldValue
                                                                          .serverTimestamp(),
                                                                });
                                                          }
                                                        } else {
                                                          if (_shouldSetState)
                                                            setState(() {});
                                                          return;
                                                        }
                                                      } finally {
                                                        await firestoreBatch
                                                            .commit();
                                                      }

                                                      if (_shouldSetState)
                                                        setState(() {});
                                                    },
                                                    text: 'Post',
                                                    options: FFButtonOptions(
                                                      width: 70.0,
                                                      height: 35.0,
                                                      padding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      iconPadding:
                                                          EdgeInsetsDirectional
                                                              .fromSTEB(
                                                                  0.0,
                                                                  0.0,
                                                                  0.0,
                                                                  0.0),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primary,
                                                      textStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .titleSmall
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                      borderSide: BorderSide(
                                                        color:
                                                            Colors.transparent,
                                                        width: 1.0,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if ((postCommentsPostsRecord
                                                      .postUser !=
                                                  currentUserReference) &&
                                              !postCommentsPostsRecord
                                                  .allowComments)
                                            Container(
                                              width: double.infinity,
                                              height: 50.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                                border: Border.all(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryText,
                                                ),
                                              ),
                                              child: Align(
                                                alignment: AlignmentDirectional(
                                                    0.0, 0.0),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          0.0, 5.0, 0.0, 5.0),
                                                  child: Text(
                                                    'The post owner has disabled comments!',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          fontFamily: 'Poppins',
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .secondaryText,
                                                          fontSize: 14.0,
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (containerUsersRecord.following
                                                  .contains(
                                                      currentUserReference) &&
                                              (currentUserDocument?.following
                                                          ?.toList() ??
                                                      [])
                                                  .contains(containerUsersRecord
                                                      .reference) &&
                                              (containerUsersRecord
                                                      .whoCanComment ==
                                                  'followers_i_follow_back') &&
                                              (containerUsersRecord.reference !=
                                                  currentUserReference))
                                            AuthUserStreamWidget(
                                              builder: (context) => Container(
                                                width: double.infinity,
                                                height: 50.0,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .secondaryBackground,
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .secondaryText,
                                                  ),
                                                ),
                                                child: Align(
                                                  alignment:
                                                      AlignmentDirectional(
                                                          0.0, 0.0),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 5.0,
                                                                0.0, 5.0),
                                                    child: Text(
                                                      'Only limited people can comment on this!',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                fontFamily:
                                                                    'Poppins',
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .secondaryText,
                                                                fontSize: 14.0,
                                                              ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ));
      },
    );
  }
}
