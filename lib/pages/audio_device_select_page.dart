import 'package:audio_monitor/audio_monitor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:radioshow_avatar/pages/audio_device_select_view_model.dart';
import 'package:radioshow_avatar/styles.dart';

class AudioDeviceSelectPage extends HookConsumerWidget {
  const AudioDeviceSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(audioDeviceSelectViewModelProvider.notifier);
    final devices =
        ref.watch(audioDeviceSelectViewModelProvider.select((s) => s.devices));
    ref.listen(audioDeviceSelectViewModelProvider.select((s) => s.isSelected),
        (_, next) {
      if (next == true) {
        Navigator.pushNamed(context, 'audioLevelSetting');
      }
    });

    useEffect(() {
      viewModel.getDevices();
      return null;
    }, []);

    return Scaffold(
      body: _DeviceList(
        list: devices,
        onSelected: viewModel.onDeviceSelected,
      ),
    );
  }
}

class _DeviceList extends StatelessWidget {
  const _DeviceList({
    required this.list,
    required this.onSelected,
  });

  final List<InputDevice> list;
  final void Function(InputDevice device) onSelected;

  @override
  Widget build(BuildContext context) {
    return list.isEmpty
        ? const SizedBox()
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () => onSelected(list[index]),
                child: Text(list[index].name, style: normalTextStyle),
              );
            });
  }
}
