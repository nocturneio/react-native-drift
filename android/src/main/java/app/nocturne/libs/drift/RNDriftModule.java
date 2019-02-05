
package app.nocturne.libs.drift;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

public class RNDriftModule extends ReactContextBaseJavaModule {

  private final ReactApplicationContext reactContext;

  public RNDriftModule(ReactApplicationContext reactContext) {
    super(reactContext);
    this.reactContext = reactContext;
  }

  @Override
  public String getName() {
    return "RNDrift";
  }
}