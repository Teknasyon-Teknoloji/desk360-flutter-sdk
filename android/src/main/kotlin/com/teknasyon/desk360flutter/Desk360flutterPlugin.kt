package com.teknasyon.desk360flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.teknasyon.desk360.helper.*

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

import io.flutter.plugin.common.PluginRegistry
import org.json.JSONObject

/** Desk360flutterPlugin */
class Desk360flutterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private lateinit var desk360Client: Desk360Client
  private var initialized = false
  companion object {
    @JvmStatic
    fun registerWith(registrar: PluginRegistry.Registrar) {
      val instance = Desk360flutterPlugin()
      val channel = MethodChannel(registrar.messenger(), "desk360flutter")
      channel.setMethodCallHandler(instance)
      instance.context = registrar.context()
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "desk360flutter")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    Log.e("FLUTTER",call.toString());
    if (call.method == "initialize") {
      val properties = call.argument<HashMap<String,Any>>("properties")
      val desk360Platform = if (properties?.get("platform") == 0) Platform.GOOGLE else Platform.HUAWEI
      val desk360Environment = if (properties?.get("environment") == 0) Environment.SANDBOX else Environment.PRODUCTION
      val appID = properties?.get("appID")
      val appVersion = properties?.get("appVersion")
      val languageCode = properties?.get("languageCode")
      val countryCode = properties?.get("countryCode")
      val name = properties?.get("name")
      val email = properties?.get("emailAddress")
      val jsonObject = properties?.get("jsonObject")
      val json = JSONObject(if (jsonObject != null) jsonObject as String else "{}")
      val desk360SDKManager = Desk360SDKManager.Builder(context)
              .setAppKey(if (appID !=null) appID as String else "")
              .setAppVersion(if (appVersion !=null) appVersion as String else "")
              .setLanguageCode(if (languageCode !=null) languageCode as String else "")
              .setPlatform(desk360Platform)
              .setCountryCode(if (countryCode !=null) countryCode as String else "")
              .setCustomJsonObject(json)
              .setUserName(if (name !=null) name as String else "")
              .setUserEmailAddress(if (email !=null) email as String else "")
              .build()
      val token = call.argument<String>("notificationToken");
      val deviceToken = call.argument<String>("deviceId");
      desk360SDKManager.initialize(token, deviceToken)
      initialized = true;
    }
    else if(call.method == "start") {
      if(initialized)
        Desk360SDK.start()
      else
        result.error("101","Desk360 not initialized", null);
    }
    else if(call.method == "getTicketId") {
      val hermes = call.argument<String>("hermes");
      val targetId = Desk360SDK.getTicketId(hermes)
      result.success(targetId)
    }
    else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
