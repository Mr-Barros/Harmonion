import SwiftUI

struct ViewController: View {
    @StateObject private var appRouter = AppRouter()
    
    @State var percussion: Int? = nil
    @State var accompaniment: Int? = nil
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                switch appRouter.router {
                case .menu:
                    MenuView(appRouter: appRouter,
                             proxy: proxy)
                case .intro:
                    IntroView(appRouter: appRouter, 
                              proxy: proxy)
                case .intro2:
                    Intro2View(appRouter: appRouter, 
                               proxy: proxy)
                case .armor:
                    ArmorView(appRouter: appRouter, 
                              proxy: proxy,
                              percussion: $percussion)
                case .weapon:
                    WeaponView(appRouter: appRouter, 
                               proxy: proxy,
                               percussion: percussion,
                               accompaniment: $accompaniment)
                case .instruction:
                    InstructionView(appRouter: appRouter,
                                    proxy: proxy)
                case .instruction2:
                    Instruction2View(appRouter: appRouter,
                                     proxy: proxy)
                case .instruction3:
                    Instruction3View(appRouter: appRouter,
                                     proxy: proxy)
                case .battle:
                    BattleView(appRouter: appRouter, 
                               proxy: proxy,
                               percussion: percussion,
                               accompaniment: accompaniment)
                case .end:
                    EndView(appRouter: appRouter,
                            proxy: proxy,
                            percussion: $percussion,
                            accompaniment: $accompaniment)
                }
            }
        }
    }
}
