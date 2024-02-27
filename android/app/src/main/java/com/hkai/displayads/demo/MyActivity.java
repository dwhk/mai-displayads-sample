/*
 * Copyright (C) 2013 Google, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.hkai.displayads.demo;

import android.os.Bundle;
import android.os.CountDownTimer;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.google.gson.Gson;
import com.hkai.displayads.DisplayAdsError;
import com.hkai.displayads.DisplayAdsInstanceController;
import com.hkai.displayads.DisplayAdsView;
import com.hkai.displayads.interfaces.ADEventHandler;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import androidx.fragment.app.FragmentActivity;

/**
 * Main Activity. Inflates main activity xml.
 */
public class MyActivity extends FragmentActivity {

    private static final String TAG = "MyActivity";

    private CountDownTimer countDownTimer;
    private Button submit;
    private boolean gameIsInProgress;
    private long timerMilliseconds;
    private EditText af;
    private EditText id;
    private EditText iu;
    private EditText sz;
    private EditText otm_params;
    private Gson gsoni;
    private FullScreenDialogFragment dialog2;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_my);

        DisplayAdsInstanceController.showDebugLog(true);
        EditText displayEndpoint = findViewById(R.id.displayEndpoint);
        EditText trackingEndpoint = findViewById(R.id.trackingEndpoint);
        af = findViewById(R.id.af);
        id = findViewById(R.id.id);
        iu = findViewById(R.id.iu);
        sz = findViewById(R.id.sz);
        otm_params = findViewById(R.id.optional_param);
        displayEndpoint.setText("https://abc/display/v2/");// need change！！
        trackingEndpoint.setText("https://abc-t/tracking/api/v1/");// need change！！
        af.setText("1");
        // af.setText("2");
        id.setText("frame1");
        iu.setText("/23456/a.pc.uat/home/bn");// need change！！
        gsoni = new Gson();
        String s1 = gsoni.toJson(new int[] { 320, 100 });
        sz.setText(s1);

        Map<String, Object> cust_paramsm = new HashMap<String, Object>();
        cust_paramsm.put("platform", "android");
        cust_paramsm.put("dtype", "phone");
        cust_paramsm.put("hdid", "8a9076abc09d22938bd21a02f05069821e0abf54e3da6c5240234b15370bebb5");
        cust_paramsm.put("pos", "1");
        Map<String, Object> optmap = new HashMap<String, Object>();

        String cust_params_str = "";
        if (cust_paramsm != null & cust_paramsm.size() > 0) {
            StringBuilder sb = new StringBuilder();
            for (Map.Entry<String, Object> entry : cust_paramsm.entrySet()) {
                sb.append(entry.getKey()).append("=").append(entry.getValue()).append("&");
            }
            sb.deleteCharAt(sb.length() - 1);
            String encoded = "";
            try {
                cust_params_str = URLEncoder.encode(sb.toString(), "UTF-8");
            } catch (UnsupportedEncodingException e) {
                Toast.makeText(MyActivity.this, e.getMessage(), Toast.LENGTH_LONG).show();

            }

        }

        optmap.put("cust_params", cust_params_str);
        optmap.put("ppid", "12345");

        Gson gson = new Gson();

        String s = gson.toJson(optmap);
        otm_params.setText(s);

        submit = findViewById(R.id.submit);
        submit.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                // Initialize the Mobile Ads SDK.
                DisplayAdsInstanceController.initialize(displayEndpoint.getText().toString(),
                        trackingEndpoint.getText().toString());
                loadADSplash();
            }
        });

    }

    private void loadADSplash() {

        try {
            String options_params_str = otm_params.getText().toString();
            Gson gson = new Gson();
            HashMap<String, Object> options_hashMap = gson.fromJson(options_params_str, HashMap.class);

            Map<String, Object> slots = new HashMap<String, Object>();

            slots.put("id", id.getText().toString());
            slots.put("iu", iu.getText().toString());
            slots.put("af", af.getText().toString());
            Gson gson2 = new Gson();
            slots.put("sz", gson2.fromJson(sz.getText().toString(), int[].class));

            if ("1".equals(af.getText().toString())) {
                DisplayAdsView DisplayAdsView = DisplayAdsInstanceController.getInstance(this).initAIgoAdBannerView(slots,
                        options_hashMap, new ADEventHandler() {
                            @Override
                            public void onAdLoadFailed(DisplayAdsError ad) {
                                Log.e(TAG, "onAdLoadFailed: ==================" + ad.errorMessage);
                                Toast.makeText(MyActivity.this,
                                        "errorCode: " + ad.errorCode + " Error: " + ad.errorMessage, Toast.LENGTH_LONG)
                                        .show();
                                if (ad.errorCode == DisplayAdsError.NO_TP_AD_ERROR) {
                                    if (dialog2 != null) {
                                        dialog2.removeAdView();
                                    }
                                }
                            }

                            @Override
                            public void onAdLoadFinished(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "AdLoadFinished...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onAdRenderFinished(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "onAdRenderFinished...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onAdPressed(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "onAdPressed...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onAdSizeChange(int width, int height) {
                            }

                            @Override
                            public void onRecordImpression(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "onRecordImpression...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onRecordImpressionFailed(DisplayAdsError ad) {
                                Toast.makeText(MyActivity.this,
                                        "errorCode: " + ad.errorCode + " Error: " + ad.errorMessage, Toast.LENGTH_LONG)
                                        .show();
                            }

                        });

                dialog2 = new FullScreenDialogFragment();
                dialog2.setContentView(DisplayAdsView);
                dialog2.show(this.getSupportFragmentManager(), "FullScreenDialog");
            } else if ("2".equals(af.getText().toString())) {
                DisplayAdsInstanceController.getInstance(this).initAIgoAdSplashView(slots, options_hashMap,
                        new ADEventHandler() {
                            @Override
                            public void onAdLoadFailed(DisplayAdsError ad) {
                                Toast.makeText(MyActivity.this,
                                        "errorCode: " + ad.errorCode + " Error: " + ad.errorMessage, Toast.LENGTH_LONG)
                                        .show();
                            }

                            @Override
                            public void onAdLoadFinished(DisplayAdsView DisplayAdsView) {
                                DisplayAdsView.showSplash(MyActivity.this);
                                Toast.makeText(MyActivity.this, "AdLoadFinished...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onAdRenderFinished(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "onAdRenderFinished...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onAdPressed(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "onAdPressed...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onAdSizeChange(int width, int height) {
                            }

                            @Override
                            public void onRecordImpression(DisplayAdsView DisplayAdsView) {
                                Toast.makeText(MyActivity.this, "onRecordImpression...", Toast.LENGTH_LONG).show();
                            }

                            @Override
                            public void onRecordImpressionFailed(DisplayAdsError ad) {
                                Toast.makeText(MyActivity.this,
                                        "errorCode: " + ad.errorCode + " Error: " + ad.errorMessage, Toast.LENGTH_LONG)
                                        .show();
                            }

                        });
            }

        } catch (Exception e) {
            e.printStackTrace();
            Toast.makeText(this, e.getMessage(), Toast.LENGTH_LONG);

        }

    }

    @Override
    public void onResume() {
        super.onResume();

    }

    @Override
    public void onPause() {
        super.onPause();
    }
}
