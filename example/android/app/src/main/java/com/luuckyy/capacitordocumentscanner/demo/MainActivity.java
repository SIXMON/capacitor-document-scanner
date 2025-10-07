package com.sixmon.capacitordocumentscanner.demo;

import com.getcapacitor.BridgeActivity;
import com.sixmon.capacitordocumentscanner.DocumentScannerPlugin;

public class MainActivity extends BridgeActivity {
    @Override
    public void onCreate(android.os.Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Register the DocumentScanner plugin
        registerPlugin(DocumentScannerPlugin.class);
    }
}