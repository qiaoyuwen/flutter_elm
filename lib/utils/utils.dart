import '../config/config.dart';

class Utils {
  //传递过来的图片地址需要处理后才能正常使用
  static String getImgPath(String path) {
    String suffix;
    if (path == null || path.isEmpty) {
      return 'http://test.fe.ptdev.cn/elm/elmlogo.jpeg';
    }
    if (path.indexOf('jpeg') != -1) {
      suffix = '.jpeg';
    } else {
      suffix = '.png';
    }
    String url = '/' + path.substring(0, 1) + '/' + path.substring(1, 3) + '/' + path.substring(3) + suffix;
    return '${Config.ImgCdnUrl}$url';
  }
}