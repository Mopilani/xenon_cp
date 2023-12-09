/// Element view is a view method of that dynamic element
/// the view method apears in storage capacity or cpu usage
/// of the units types, it's a strings by default
class NumbersView {
  // late dynamic _element;
  late String string;
  late num number;
  late int integer;
  late dynamic value;

  // NumbersView.fromNumber(num _number);

  NumbersView(Object element) {
    if (element is num) {
      value = element;
      number = element;
      integer = number.toInt();
      string = element.toString();
    } else if (element is String) {
      var parseResult = num.tryParse(element);
      string = element;
      if (parseResult == null) {
        throw 'We cant find numbers element in the given $element';
      } else {
        value = element;
        number = parseResult;
        integer = number.toInt();
      }
    } else {
      throw 'Element of type ${element.runtimeType} is not supported';
    }
  }

  NumbersView operator +(NumbersView other) {
    // try {
    //   integer + other.integer;
    //   number + other.number;
    // } catch (e) {
    //   // print(e);
    //   number + other.number;
    // }
    // print('--------$number');
    // value = number;
    // string = value.toString();
    var value = number + other.number;
    return NumbersView(value)
      ..integer = value.toInt()
      ..value = (value)
      ..string = (value).toString();
  }

  NumbersView operator -(NumbersView other) {
    var value = number - other.number;
    return NumbersView(value)
      ..integer = value.toInt()
      ..value = (value)
      ..string = (value).toString();
    // value = number;
    // string = value.toString();
    // return this;
  }

  NumbersView operator *(NumbersView other) {
    var value = number * other.number;
    return NumbersView(value)
      ..integer = value.toInt()
      ..value = (value)
      ..string = (value).toString();
    // try {
    //   integer * other.integer;
    //   number * other.number;
    // } catch (e) {
    //   number * other.number;
    // }
    // value = number;
    // string = value.toString();
    // return this;
  }

  NumbersView operator /(NumbersView other) {
    var value = number / other.number;
    return NumbersView(value)
      ..integer = value.toInt()
      ..value = (value)
      ..string = (value).toString();
    // try {
    //   integer / other.integer;
    //   number / other.number;
    // } catch (e) {
    //   number / other.number;
    // }
    // value = number;
    // string = value.toString();
    // return this;
  }
  NumbersView operator %(NumbersView other) {
    var value = number / other.number;
    return NumbersView(value)
      ..integer = value.toInt()
      ..value = (value)
      ..string = (value).toString();
  }
  // bool operator >>>(NumbersView other) {
  //   return (this != null);
  // }

  @override
  String toString() {
    return value.toString();
  }
}
// class MatView extends ElementView {
//   MatView(this.);
// }
