package com.hkai.displayads.demo;

import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.hkai.displayads.DisplayAdsView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.DialogFragment;


public class FullScreenDialogFragment extends DialogFragment {
    private DisplayAdsView contentView;
    private int adWidth;
    private int adHeight;
    private LinearLayout ad_container;
    private String TAG="FullScreenDialogFragment";

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setStyle(DialogFragment.STYLE_NO_TITLE, android.R.style.Theme_Black_NoTitleBar_Fullscreen);
    }
    @Nullable
    @Override
    public View onCreateView(@NonNull LayoutInflater inflater, @Nullable ViewGroup container, @Nullable Bundle savedInstanceState) {
        Context context = contentView.getContext();
        RelativeLayout inflate = (RelativeLayout) inflater.inflate(R.layout.layout_full_f, container);
         ad_container = inflate.findViewById(R.id.ad_container);
        Button button = inflate.findViewById(R.id.back);

        button.setText("Back");
        button.setOnClickListener((v)-> {Log.e("Button", "close: ");
            FullScreenDialogFragment.this.dismiss();}
        );
        ad_container.addView(contentView);
        return inflate;
    }


    @Override
    public void onStart() {
        super.onStart();
        Window window = getDialog().getWindow();
        if (window != null) {
            WindowManager.LayoutParams params = window.getAttributes();
            params.width = WindowManager.LayoutParams.MATCH_PARENT;
            params.height = WindowManager.LayoutParams.MATCH_PARENT;
            params.gravity = Gravity.CENTER;
            window.setAttributes(params);
        }

    }

    public void setContentView(DisplayAdsView contentView) {
        this.contentView = contentView;
    }


    public void removeAdView() {
        if(ad_container!=null&&contentView!=null) {
            ad_container.removeView(contentView);
        }
    }
}
