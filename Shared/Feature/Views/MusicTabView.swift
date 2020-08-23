//
//  CustomTabView.swift
//  HypeLove
//
//  Created by Jaume on 22/08/2020.
//

import SwiftUI

struct MusicTabView<SelectionValue, Content, TabContent>: View where SelectionValue: Hashable & CaseIterable, SelectionValue.AllCases: RandomAccessCollection, Content: View, TabContent: View {
    
    @EnvironmentObject var player: Player
    @Binding var selection: SelectionValue
    @Binding var hiddenTabBar: Bool
    private let contentBuilder: (SelectionValue) -> Content
    private let tabsBuilder: (SelectionValue) -> TabContent
    let barHeight: CGFloat = 40
    
    init(_ selection: Binding<SelectionValue>,
         hiddenTabBar: Binding<Bool>,
         @ViewBuilder content: @escaping (SelectionValue) -> Content,
         @ViewBuilder tabs: @escaping (SelectionValue) -> TabContent) {
        
        _selection = selection
        _hiddenTabBar = hiddenTabBar
        self.contentBuilder = content
        self.tabsBuilder = tabs
    }
    
    @ViewBuilder
    func blurBackgroundView() -> some View {
        if hiddenTabBar && player.currentTrack == nil {
            EmptyView()
        } else {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                .clipShape(RoundedRectangleCustomCorners(cornerRadius: player.currentTrack == nil ? 0 : 20, roundedCorners: [.topLeft, .topRight]))
                .ignoresSafeArea(.all, edges: [.bottom, .leading, .trailing])
                .animation(.default)
                .transition(.offset(x: 0, y: barHeight * 2))
        }
    }
    
    var body: some View {
        
        ZStack {
            
            //Content
            contentBuilder(selection)
                .zIndex(0)
            
            
            VStack {
                
                Spacer()
                
                VStack {
                    
                    //Now playing
                    if player.currentTrack != nil {
                        NowPlayingView()
                            .zIndex(player.currentTrack == nil ? 1 : 3)
                            .transition(.offset(x: 0, y: barHeight * 4))
                    }
                    
                    //Tabbar
                    if !hiddenTabBar {
                        
                        HStack {
                            ForEach(SelectionValue.allCases, id: \.self) { selectionValue in
                                Button(action: {
                                    selection = selectionValue
                                }, label: {
                                    tabsBuilder(selectionValue)
                                })
                                .frame(maxWidth: .infinity)
                                .if(selectionValue != selection) { $0.accentColor(.gray) }
                            }
                        }
                        .frame(width: UIScreen.main.bounds.width, height: barHeight)
                        .padding(.top, 10)
                        
                        //Tabbar line
                        .overlay(
                            VStack {
                                Divider()
                                Spacer()
                            }
                        )
                        
                        .transition(.offset(x: 0, y: barHeight * 2))
                        .ignoresSafeArea(.all, edges: [.bottom, .leading, .trailing])
                        .zIndex(2)
                        
                    }
                }
                .animation(.default)
                .background(blurBackgroundView())
            }
        }
    }
}
