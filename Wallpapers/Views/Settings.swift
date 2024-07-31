//
//  Settings.swift
//  Wallpapers
//
//  Created by 高子蒙 on 2023/8/26.
//

import Carbon
import MarkdownUI
import SwiftUI

func toggle() {
  print("active")
  let script: NSAppleScript = {
    let script = NSAppleScript(source: """
      on displayMessage(message)
          tell application "Finder"
              activate
              display dialog message buttons {"OK"} default button "OK"
          end tell
      end displayMessage
      """
    )!
    let success = script.compileAndReturnError(nil)
    assert(success)
    return script
  }()
  let parameters = NSAppleEventDescriptor.list()
  parameters.insert(NSAppleEventDescriptor(string: "Hello Cruel World!"), at: 0)

  let event = NSAppleEventDescriptor(
    eventClass: AEEventClass(kASAppleScriptSuite),
    eventID: AEEventID(kASSubroutineEvent),
    targetDescriptor: nil,
    returnID: AEReturnID(kAutoGenerateReturnID),
    transactionID: AETransactionID(kAnyTransactionID)
  )
  event.setDescriptor(NSAppleEventDescriptor(string: "displayMessage"), forKeyword: AEKeyword(keyASSubroutineName))
  event.setDescriptor(parameters, forKeyword: AEKeyword(keyDirectObject))

  var error: NSDictionary?
  let result = script.executeAppleEvent(event, error: &error) as NSAppleEventDescriptor?
  print("result: \(String(describing: result))")
  print("error: \(String(describing: error))")
}

struct SettingsView: View {
  @EnvironmentObject var store: Store
  @State private var index = 0

  var body: some View {
    TabView {
      PreferencesSettingsView()
        .environmentObject(store)
        .tabItem {
          Label("Preferences", systemImage: "photo")
        }
      GeneralSettingsView()
        .environmentObject(store)
        .tabItem {
          Label("General", systemImage: "folder.fill.badge.minus")
        }
      AcknowledgmentView()
        .environmentObject(store)
        .tabItem {
          Label("Acknowledgment", systemImage: "book.circle")
        }
    }
    .padding(15)
    .tabViewStyle(.automatic)
    .tableStyle(.automatic)
    .frame(minWidth: 200, maxWidth: 600, minHeight: 400)
  }
}

struct PreferencesSettingsView: View {
  @EnvironmentObject var store: Store
  @AppStorage("defaultGeneral") var selection: Int = 1

  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        Text("Preferences").font(.title2)

        Spacer().frame(height: 10).frame(maxWidth: .infinity)

        Form {
          VStack(alignment: .leading, spacing: 25) {
            HStack {
              Text("Starup").bold().frame(width: 100, alignment: .trailing)
              Spacer().frame(width: 30)
              RoundedRectangle(cornerRadius: 2)
                .stroke(style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [3, 3], dashPhase: 10))
                .frame(width: 16, height: 16)
//                .background(Color.yellow)
              Text("Auto Login")
            }
            HStack {
              Text("Appearance").bold().padding(0).frame(width: 100, alignment: .trailing).lineLimit(1)
              Spacer().frame(width: 30)
              Button(action: {
                store.toggleDark()
              }) {
                Image(systemName: store.isDarkMode ? "sun.max.circle" : "moon.circle")
                  .IconStyle()
                  .padding(.horizontal, 15)
                  .padding(.vertical, 10)
                  .background(store.isDarkMode
                    ? Color.gray
                    : Color.white)
                  .cornerRadius(5)
              }
            }
            .buttonStyle(.plain)

            HStack {
              Text("Pick").bold().frame(width: 100, alignment: .trailing)
              Spacer().frame(width: 30)
              Picker(selection: $selection, label: Text("")) {
                Text("Day").tag(0)
                Text("Hour").tag(1)
              }
              .pickerStyle(.menu)
              .labelsHidden()
            }

            HStack {
              Text("Open Pictrue Directory").bold().padding(0).frame(width: 100, alignment: .trailing).lineLimit(1)
              Spacer().frame(width: 30)
              Button(action: {
                DownloadService.openDownloadPrctrueDirectroy()
              }) {
                Image(systemName: "opticaldiscdrive")
                  .IconStyle()
                  .padding(.horizontal, 15)
                  .padding(.vertical, 10)
                  .background(store.isDarkMode
                    ? Color.gray
                    : Color.white)
                  .cornerRadius(5)
              }.plain()
            }

            HStack {
              Text("Clean Cache").bold().padding(0).frame(width: 100, alignment: .trailing).lineLimit(1)
              Spacer().frame(width: 30)
              Button(action: {
                ImageService.cleanCache()
              }) {
                Image(systemName: "trash")
                  .IconStyle()
                  .padding(.horizontal, 15)
                  .padding(.vertical, 10)
                  .background(store.isDarkMode
                    ? Color.gray
                    : Color.white)
                  .cornerRadius(5)
              }.plain()
            }
          }
        }

        Spacer()

        Button(action: {
          NSApplication.shared.terminate(nil)
        }) {
          Text("Quit")
            .bold()
            .font(.title3)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 15)
            .background(store.isDarkMode ? Color.gray : Color.white)
            .cornerRadius(15)
        }.plain()
      }
      .padding(.horizontal, 30)
      .padding(.vertical, 20)
    }
    .listStyle(.plain)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

extension View {
  func scroll() -> some View {
    ScrollView(showsIndicators: false) {
      self
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
    .listStyle(.plain)
  }
}

struct GeneralSettingsView: View {
  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("general")
      Button("Click", action: {
        toggle()
      })
    }.scroll().frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct AcknowledgmentView: View {
  @ObservedObject var viewModel = ReadmeViewModel()
  var body: some View {
    ScrollView(showsIndicators: false) {
      VStack(alignment: .leading, spacing: 10) {
        Markdown {
          viewModel.readmeText
        }
      }
      .padding(.horizontal, 20)
    }
    .listStyle(.plain)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
  }
}

struct SettingsView_Previews: PreviewProvider {
  static let store = Store()
  static var previews: some View {
    SettingsView().environmentObject(store)
  }
}
