// iconfont 转 fluter icon 脚本
const http = require('http');
const fs = require('fs');
const path = require('path');
const key = 'font_2546941_dcwzsv12j54' // iconfont 项目id
const url = 'http://at.alicdn.com/t/' + key;
const iconfix = 'icon-'; // 图标前缀
const fontFamily = 'IconFont' //  pubspec.yaml 申明的字体类型
const outPathIcon = './iconfont.dart';
const outPathSvg = './svg.dart';
const outPathTTF = '../../assets/fonts/iconfont.ttf';

if (!key) return;

String.prototype.replaceAll = function (str, str2) {
    return this.split(str).join(str2)
}

// svg
http.get(url + '.js', function (res) {
    res.setEncoding('utf8');
    let rawData = '';
    res.on('data', (chunk) => { rawData += chunk; });
    res.on('end', () => {
        let obj = {};
        let reg = new RegExp(`(<symbol .*?"${iconfix}(.*?)".*?</symbol>)`, 'g')
        while ((arr = reg.exec(rawData)) !== null) {
            let key = arr[2].replaceAll('-', '_');
            obj[key] = arr[1].replace('<symbol', '<svg').replace('</symbol>', '</svg>')
        }
        writeFile(path.resolve(__dirname, outPathSvg), getDartSvgStr(obj))
    })
});

// icon
http.get(url + '.css', function (res) {
    res.setEncoding('utf8');
    let rawData = '';
    res.on('data', (chunk) => { rawData += chunk; });
    res.on('end', () => {
        let str = [];
        let keys = [];
        let reg = new RegExp(`.${iconfix}(.*?):(.|\\n)*?"\\\\(.*?)";`, 'gm')
        while ((arr = reg.exec(rawData)) !== null) {
            let name = arr[1].replaceAll('-', '_');
            let codePoint = arr[3];
            keys.push(`    '${name}': ${name},`)
            str.push(`  static const IconData ${name} = IconData(0x${codePoint}, fontFamily: _family);`);
        }
        writeFile(path.resolve(__dirname, outPathIcon), getDartIconStr(str,keys, fontFamily));
    });
})

// 字体
http.get(url + '.ttf', function (res) {
    let stream = fs.createWriteStream(path.resolve(__dirname, outPathTTF));
    res.pipe(stream).on('close', function () {
        console.log('ttf 字体文件下载完成')
    })
})

/**
 * x文件写入
 * @param {*} path 
 * @param {*} str 
 */
function writeFile(path, str) {
    fs.writeFile(path, str, (err) => {
        if (err) {
            console.log(err)
        } else {
            console.log(`写入文件: ${path}`)
        }
    })
}
/**
 * 生成 IconData 
 * @param {*} arr 
 * @param {*} fontFamily 
 */
function getDartIconStr(arr,keys, fontFamily) {
    return `import 'package:flutter/widgets.dart';

/// @date: ${new Date()}
/// @source-url ${url + '.css'}
/// @description  代码由程序自动生成。请不要对此文件做任何修改。

class IconFont extends IconSwatch<IconData>{
  static const String _family = '${fontFamily}';
${arr.join('\n')}

  static IconFont icon = IconFont();
  Map<String, IconData> _map = {
${keys.join('\n')}
  };
}

class IconSwatch<T> {
  Map<String, T> _map;
  int get length => _map.length;
  Iterable<String> get keys => _map.keys;
  T operator [](String key) {
    return _map[key];
  }
}
`;
}

/**
 * 生成 Svg
 * @param {*} obj 
 */
function getDartSvgStr(obj) {
    let enumStr = '';
    let arr = [];
    for (const key in obj) {
        if (obj.hasOwnProperty(key)) {
            enumStr += ' \n  ' + key + ',';
            arr.push(`  "${key}": '''${obj[key]}''',`)
        }
    }

    return `import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
    
/// @date: ${new Date()}
/// @source-url ${url + '.js'}
/// @description  代码由程序自动生成。请不要对此文件做任何修改。

enum SvgNames { ${enumStr} }
    
final Map<String, String> _svgSource = {
${arr.join('\n')}
};


class MySvg extends StatelessWidget {
  final double width;
  final double height;
  final SvgNames svgNames;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final bool matchTextDirection;
  final bool allowDrawingOutsideViewBox;
  final String semanticsLabel;
  final WidgetBuilder placeholderBuilder;
  final bool excludeFromSemantics;
  final Color color;
  final Clip clipBehavior;
  final BlendMode colorBlendMode;
  
  const MySvg(
    this.svgNames, {
    Key key,
    this.width = 16,
    this.height = 16,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    this.matchTextDirection = false,
    this.allowDrawingOutsideViewBox = false,
    this.placeholderBuilder,
    this.semanticsLabel,
    this.excludeFromSemantics = false,
    this.clipBehavior = Clip.hardEdge,
    this.color,
    this.colorBlendMode = BlendMode.srcIn,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      _svgSource[svgNames.toString().split('.').last],
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      matchTextDirection: matchTextDirection,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      clipBehavior: clipBehavior,
      color: color,
      colorBlendMode: colorBlendMode,
    );
  }
}
`;
}