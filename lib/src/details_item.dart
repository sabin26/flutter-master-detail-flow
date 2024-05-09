import 'package:flutter/material.dart';
import 'package:master_detail_flow/src/enums.dart';
import 'package:master_detail_flow/src/flow_settings.dart';
import 'package:master_detail_flow/src/padding_utils.dart';

/// An M3 details page to be used in a MasterDetailFlow. It adapts using
/// MasterDetailsFlowSettings provided by the MasterDetailsFlow
class DetailsItem extends StatelessWidget {
  /// Creates an M3 details page
  const DetailsItem({
    required this.title,
    this.children,
    this.slivers,
    this.actions,
    this.lateralDetailsAppBar,
    this.pageDetailsAppBar,
    this.pageAppBarColor,
    this.centerTitleForPage = false,
    super.key,
  });

  /// The title widget to be used in the app bar of the details page
  final Widget title;

  /// Aligns the title to center when it is in page mode.
  final bool centerTitleForPage;

  /// A list of Widgets to display in a row after the [title] widget.
  ///
  /// Typically these widgets are [IconButton]s representing common operations.
  /// For less common operations, consider using a [PopupMenuButton] as the
  /// last action.
  final List<Widget>? actions;

  /// The children to be shown by the details page in a list
  final List<Widget>? children;

  /// An optional list of slivers to be showed under [children] for creating
  /// advanced effects or to provide a SliverList with a builder delegate or a
  /// SliverFillViewport
  final List<Widget>? slivers;

  /// Overrides for the parameters in [MasterDetailsFlow]. See
  /// [MasterDetailsFlow.lateralDetailsAppbar] and
  /// [MasterDetailsFlow.pageDetailsAppBar]
  final DetailsAppBarSize? lateralDetailsAppBar, pageDetailsAppBar;

  /// Background color for appbar when it is in page mode.
  final Color? pageAppBarColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final MasterDetailsFlowSettings? settings =
        MasterDetailsFlowSettings.of(context);
    return PopScope(
      canPop: !(settings?.selfPage ?? false),
      onPopInvoked: (final bool value) async {
        if (settings?.selfPage == true) {
          settings!.goBack!();
        }
      },
      child: CustomScrollView(
        slivers: <Widget>[
              _sliverAppBar(settings, colorScheme),
              if (children != null)
                SliverList(
                  delegate: SliverChildListDelegate.fixed(children!),
                ),
            ] +
            (slivers ?? <Widget>[]) +
            <Widget>[
              const SliverFinalPadding(),
            ],
      ),
    );
  }

  SliverAppBar _sliverAppBar(
      MasterDetailsFlowSettings? settings, ColorScheme colorScheme) {
    final bool selfPage = settings?.selfPage ?? false;
    final DetailsAppBarSize detailsAppBar =
        (selfPage ? pageDetailsAppBar : lateralDetailsAppBar) ??
            settings?.appBarSize ??
            DetailsAppBarSize.small;

    switch (detailsAppBar) {
      case DetailsAppBarSize.small:
        return SliverAppBar(
          title: title,
          centerTitle: selfPage ? centerTitleForPage : null,
          actions: actions,
          primary: settings?.selfPage ?? false,
          backgroundColor:
              pageAppBarColor ?? _backgroundColor(colorScheme, settings),
          automaticallyImplyLeading: false,
          leading: _leadingButton(settings),
        );
      case DetailsAppBarSize.medium:
        return SliverAppBar.medium(
          title: title,
          centerTitle: selfPage ? centerTitleForPage : null,
          actions: actions,
          primary: settings?.selfPage ?? false,
          backgroundColor:
              pageAppBarColor ?? _backgroundColor(colorScheme, settings),
          automaticallyImplyLeading: false,
          leading: _leadingButton(settings),
        );
      case DetailsAppBarSize.large:
        return SliverAppBar.large(
          title: title,
          centerTitle: selfPage ? centerTitleForPage : null,
          actions: actions,
          primary: settings?.selfPage ?? false,
          backgroundColor:
              pageAppBarColor ?? _backgroundColor(colorScheme, settings),
          automaticallyImplyLeading: false,
          leading: _leadingButton(settings),
        );
    }
  }

  IconButton? _leadingButton(MasterDetailsFlowSettings? settings) {
    return (settings?.selfPage ?? false)
        ? IconButton(
            onPressed: settings!.goBack,
            icon: Icon(Icons.adaptive.arrow_back),
          )
        : null;
  }

  Color _backgroundColor(
      ColorScheme colorScheme, MasterDetailsFlowSettings? settings) {
    return ElevationOverlay.applySurfaceTint(
      colorScheme.surface,
      colorScheme.surfaceTint,
      (settings?.selfPage ?? false) ? 0 : 1,
    );
  }
}
