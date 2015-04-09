package extapp;
import android.content.Context;
import core.interfaces.DoIAppDelegate;

/**
 * APP启动的时候会执行onCreate方法；
 *
 */
public class do_BaiduLocation_App implements DoIAppDelegate {

	private static do_BaiduLocation_App instance;
	
	@Override
	public void onCreate(Context context) {
		instance = this;
		// ...do something
		
	}
	
	public static do_BaiduLocation_App getInstance() {
		return instance;
	}

}
