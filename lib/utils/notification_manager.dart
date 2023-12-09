import 'dart:io';

class NotificationsManager {
  /// To initialize a new instance with old data
  NotificationsManager.init(Map<String, dynamic> other) {}

  Future notify(document) async {
    await Process.run('notifier.exe', ['-doc', document]);
  }
}

class XMLDocMaker {
  addAction() {}
  toast() {}

  @override
  String toString() {
    return '';
  }
}

class _Toast {
  action() {
    return _Action();
  }
}

class _Action {
  _Action();
  action() {
    return _Action();
  }
}

class XMLToastsTemplates {
  temp1() {
    return '''<toast launch="app-defined-string">

    <visual>
        <binding template="ToastGeneric">
        ...
        </binding>
    </visual>

    <actions>
        ...
    </actions>

    <audio src="ms-winsoundevent:Notification.Reminder"/>

</toast>
''';
  }

  temp2() {
    return '''<toast launch="app-defined-string">

    <visual>
        <binding template="ToastGeneric">
            <text hint-maxLines="1">Adaptive Tiles Meeting</text>
            <text>Conf Room 2001 / Building 135</text>
            <text>10:00 AM - 10:30 AM</text>
        </binding>
    </visual>

</toast>
''';
  }

  /// App logo override
  temp3({required String imageSrc}) {
    return '''<toast launch="app-defined-string">

    <visual>
        <binding template="ToastGeneric">
            ...
            <image placement="appLogoOverride" hint-crop="circle" src="https://picsum.photos/48?image=883"/>
        </binding>
    </visual>

</toast>
''';
  }

  /// Hero Image
  temp4() {
    return '''<toast launch="app-defined-string">

    <visual>
        <binding template="ToastGeneric">
            ...
            <image placement="hero" src="https://picsum.photos/364/180?image=1043"/>
        </binding>
    </visual>

</toast>''';
  }

  /// Inline Image
  temp5() {
    return '''<toast launch="app-defined-string">

    <visual>
        <binding template="ToastGeneric">
            ...
            <image src="https://picsum.photos/360/202?image=1043" />
        </binding>
    </visual>

</toast>''';
  }

  /// Attribution text
  temp6() {
    return '''<toast launch="app-defined-string">

    <visual>
        <binding template="ToastGeneric">
            ...
            <text placement="attribution">Via SMS</text>
        </binding>
    </visual>

</toast>''';
  }

  /// Custom timestamp
  temp7() {
    return '''''';
  }

  temp8() {
    return '''''';
  }

  // temp2() {
  //   return '''''';
  // }
}
