// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:upgrader/upgrader.dart';

// import '../../../../../config/config_exports.dart';
// import '../../../../core_exports.dart';

// /// Custom UpgradeAlert widget that uses a custom dialog
// class CustomUpgradeAlert extends UpgradeAlert {
//   CustomUpgradeAlert({super.key, super.upgrader, super.child});

//   @override
//   UpgradeAlertState createState() => CustomUpgradeAlertState();
// }

// /// Custom state that overrides the dialog display
// class CustomUpgradeAlertState extends UpgradeAlertState {
//   @override
//   void showTheDialog({
//     required BuildContext context,
//     required String? title,
//     required String message,
//     required String? releaseNotes,
//     required bool barrierDismissible,
//     required UpgraderMessages messages,
//     Key? key,
//   }) {
//     showDialog(
//       context: context,
//       barrierDismissible: barrierDismissible,
//       builder: (BuildContext context) {
//         return CustomUpgraderDialog(
//           key: key,
//           newVersion: widget.upgrader.currentAppStoreVersion ?? '1.0.1',
//           currentVersion: widget.upgrader.currentInstalledVersion ?? '1.0.0',
//           releaseNotes: releaseNotes,
//           onUpdateLater: () {
//             onUserLater(context, true);
//           },
//           onUpdateNow: () {
//             onUserUpdated(context, !widget.upgrader.blocked());
//           },
//           showLaterButton: !widget.upgrader.blocked(),
//         );
//       },
//     );
//   }
// }

// /// The custom dialog widget with your design
// class CustomUpgraderDialog extends StatelessWidget {
//   const CustomUpgraderDialog({
//     required this.newVersion,
//     required this.currentVersion,
//     required this.onUpdateLater,
//     required this.onUpdateNow,
//     super.key,
//     this.releaseNotes,
//     this.showLaterButton = true,
//   });
//   final String newVersion;
//   final String currentVersion;
//   final String? releaseNotes;
//   final VoidCallback onUpdateLater;
//   final VoidCallback onUpdateNow;
//   final bool showLaterButton;

//   // Define colors from the design
//   static const kGreenColor = AppColors.green;
//   static const kDarkBlueColor = AppColors.primary;
//   static const kLightBlueBg = AppColors.primaryLight;
//   static const kGreyText = AppColors.greyDark2;
//   static const kTopGradientStart = Color(0xFFFFF3E0);
//   static const kTopGradientEnd = AppColors.white;

//   List<String> _parseReleaseNotes() {
//     if (releaseNotes == null || releaseNotes!.isEmpty) {
//       return ['Bug Fixes'];
//     }

//     // Parse release notes - handle both bullet points and plain text
//     final notes = releaseNotes!
//         .split('\n')
//         .map((line) => line.trim())
//         .where((line) => line.isNotEmpty)
//         .map((line) {
//           // Remove common bullet point characters
//           return line.replaceFirst(RegExp(r'^[•\-*]\s*'), '');
//         })
//         .where((line) => line.isNotEmpty)
//         .toList();

//     return notes.isNotEmpty ? notes : ['Bug fixes and improvements.'];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final parsedNotes = _parseReleaseNotes();

//     return Dialog(
//       shape: RoundedRectangleBorder(borderRadius: 24.borderCircular),
//       backgroundColor: AppColors.transparent,
//       insetPadding: 24.horizontalPadding,
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: 24.borderCircular,
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment(0, 0.3),
//             colors: [kTopGradientStart, kTopGradientEnd],
//           ),
//           color: AppColors.white,
//         ),
//         padding: 24.allPadding,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Icon container
//             AppImage.assetIcon(
//               Assets.images.updateAlert.path,
//               height: 60.h,
//               width: 60.w,
//             ),
//             20.verticalGap,
//             // Title
//             Text.rich(
//               TextSpan(
//                 children: [
//                   TextSpan(
//                     text: LocaleKeys.common_words_update.tr(),
//                     style: AppTextStyles.mobileHeading3.copyWith(
//                       color: kGreenColor,
//                     ),
//                   ),
//                   TextSpan(
//                     text: LocaleKeys.common_sentences_available.tr(),
//                     style: AppTextStyles.mobileHeading3.copyWith(
//                       color: AppColors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             16.verticalGap,

//             // Body Text
//             Text.rich(
//               TextSpan(
//                 style: AppTextStyles.mobileBody1.copyWith(color: kGreyText),
//                 children: [
//                   TextSpan(text: LocaleKeys.common_sentences_a_newer_version_of_tidy_days.tr()),
//                   TextSpan(
//                     text: 'v$newVersion',
//                     style: AppTextStyles.mobileBody1.copyWith(
//                       color: AppColors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(
//                     text: LocaleKeys.common_sentences_is_ready_for_younyoure_current.tr(),
//                   ),
//                   TextSpan(
//                     text: 'v$currentVersion',
//                     style: AppTextStyles.mobileBody1.copyWith(
//                       color: AppColors.black,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   TextSpan(text: LocaleKeys.common_words_n.tr()),
//                   TextSpan(
//                     text: LocaleKeys.common_sentences_update_now_for_the_latest_impr.tr(),
//                     style: AppTextStyles.mobileSubtitle2.copyWith(
//                       color: kDarkBlueColor,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             24.verticalGap,

//             // Release Notes Container
//             Container(
//               width: double.infinity,
//               constraints: BoxConstraints(maxHeight: 200.h),
//               padding: EdgeInsets.all(20.w),
//               decoration: BoxDecoration(
//                 color: kLightBlueBg,
//                 borderRadius: BorderRadius.circular(16.r),
//                 border: Border.all(color: Color(0xFFD0E4F7)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Text(
//                     'Release Notes',
//                     style: AppTextStyles.mobileTitle2.copyWith(
//                       color: kDarkBlueColor,
//                     ),
//                   ),
//                   SizedBox(height: 12.h),
//                   Flexible(
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: parsedNotes
//                             .map(
//                               (note) =>
//                                   _buildReleaseNoteItem(note, kDarkBlueColor),
//                             )
//                             .toList(),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 32.h),

//             // Buttons Row
//             Row(
//               children: [
//                 // Update Later Button (only show if not blocked)
//                 if (showLaterButton) ...[
//                   Expanded(
//                     child: AppButton.custom(
//                       onPressed: onUpdateLater,
//                       label: LocaleKeys.common_sentences_update_later.tr(),
//                       prefix: Icon(Icons.schedule, size: 20.sp),
//                       theme: CustomButtonTheme(
//                         showBorder: true,
//                         border: BorderSide(color: AppColors.greyLightActive),
//                         backgroundColor: AppColors.transparent,
//                         foregroundColor: AppColors.black,
//                       ),
//                     ),
//                   ),
//                   16.horizontalGap,
//                 ],
//                 // Update Now Button
//                 Expanded(
//                   child: AppButton.primary(
//                     onPressed: onUpdateNow,
//                     label: LocaleKeys.common_sentences_update_now.tr(),
//                     prefix: Icon(
//                       Icons.check_circle_outline,
//                       size: 20.sp,
//                       color: AppColors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildReleaseNoteItem(String text, Color color) {
//     return Padding(
//       padding: 8.bottomOnly,
//       child: Expanded(
//         child: Text.rich(
//           TextSpan(
//             style: AppTextStyles.mobileBody1.copyWith(color: AppColors.primary),
//             children: [
//               const TextSpan(text: '✦ '),
//               TextSpan(
//                 text: text,
//                 style: AppTextStyles.mobileBody1.copyWith(color: kGreyText),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // USAGE EXAMPLE:
// // In your App widget:
// //
// // class App extends StatelessWidget {
// //   App({super.key});
// //
// //   final AppRouter _appRouter = sl<AppRouter>();
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final myUpgrader = Upgrader(
// //       debugLogging: true,
// //       showIgnore: false,
// //       showLater: true,
// //       showReleaseNotes: true,
// //     );
// //
// //     return GlobalBlocProvider(
// //       child: ScreenUtilInit(
// //         designSize: const Size(428, 926),
// //         minTextAdapt: true,
// //         splitScreenMode: true,
// //         builder: (_, child) {
// //           return CustomUpgradeAlert(
// //             upgrader: myUpgrader,
// //             child: MaterialApp.router(
// //               debugShowCheckedModeBanner: false,
// //               localizationsDelegates: context.localizationDelegates,
// //               supportedLocales: context.supportedLocales,
// //               locale: context.locale,
// //               theme: AppTheme.lightTheme,
// //               themeMode: ThemeMode.light,
// //               routerConfig: _appRouter.config(
// //                 navigatorObservers: () => [sl<AppRouteObserver>()],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
