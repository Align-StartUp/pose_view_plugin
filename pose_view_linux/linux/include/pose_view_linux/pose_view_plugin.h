#ifndef FLUTTER_PLUGIN_POSE_VIEW_LINUX_PLUGIN_H_
#define FLUTTER_PLUGIN_POSE_VIEW_LINUX_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

G_DECLARE_FINAL_TYPE(FlPoseViewPlugin, fl_pose_view_plugin, FL,
                     POSE_VIEW_PLUGIN, GObject)

FLUTTER_PLUGIN_EXPORT FlPoseViewPlugin* fl_pose_view_plugin_new(
    FlPluginRegistrar* registrar);

FLUTTER_PLUGIN_EXPORT void pose_view_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_POSE_VIEW_LINUX_PLUGIN_H_