import android.media.MediaPlayer;
import android.content.res.AssetFileDescriptor;
import android.os.Environment;
class PAudio {
  MediaPlayer player;
  long tap;
  PAudio(String path,boolean repeat) {
    try {
      player = new MediaPlayer();
      if (path.startsWith("ex.")) {
        String apath="/storage/emulated/0/RawEngine/"+APP_ID+"/"+path.substring(3);
        //String apath=Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC)+ "/music.mp3";
        //println(apath);
        player.setDataSource(apath);
      } else {
        AssetFileDescriptor desc = getActivity().getApplicationContext().getAssets().openFd(path);
        player.setDataSource(desc.getFileDescriptor(),desc.getStartOffset(),desc.getLength());
      }
      player.setLooping(repeat);
      player.prepare();
      tap=millis();
    } catch (IOException ex) {
      String err_msg="Audio file "+path+" not found";
      player=null;
      if (STRICT_AUDIO)
        throw new RuntimeException(err_msg);
      else println(err_msg);
    }
  }
  void start() {
    println("Start playing. Player exists:",player!=null);
    if (player!=null)
      player.start();
  }
  void pause() {
    if (player!=null)
      player.pause();
  }
  void stop() {
    println("Stop playing");
    if (player!=null)
      player.stop();
  }
  void upd() {
    if (player==null)
      return;
    if (millis()-tap<1000) {
      float v=((float)millis()-tap)/1000*MUSIC_VOLUME;
      player.setVolume(v,v);
    println(v);
    }
  }
  boolean isPlaying() {
    return player==null||player.isPlaying();
  }
}