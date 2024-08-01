//
//  StudyWallApp.swift
//  StudyWall
//
//  Created by 村田直紀 on 2024/07/27.
//

import SwiftUI

// LandmarksAppはアプリのエントリーポイントを定義する構造体です。
// @main属性を持つ構造体は、アプリの開始点を示します。
@main
struct StudyWallApp: App {
    // @StateプロパティラッパーはSwiftUIでデータの状態を管理します。
    // modelDataはアプリ全体で共有されるデータを保持します。
    @State private var modelData = ModelData()

    // bodyはアプリのUIを構成するSceneを定義します。
    var body: some Scene {
        // WindowGroupはアプリの主要なウィンドウを作成します。
        WindowGroup {
            // ContentViewはアプリのメインビューで、ここに表示されます。
            // .environment(_:)修飾子を使って、modelDataを環境オブジェクトとしてビューに提供します。
            ContentView()
                .environment(modelData)
        }
    }
}
