//
//  HSK5Widget.swift
//  HSK5Widget
//
//  Created by Tania Yeromiyan on 16/01/2021.
//
import WidgetKit
import SwiftUI

@available (iOS 14, *)



struct VocabEntry: TimelineEntry {
    let date = Date()
    var vocab: ChineseVocab
    
}
struct Provider: TimelineProvider {
    
    @AppStorage(Constants.UDselectedVocab, store: UserDefaults(suiteName: "group.com.themodernmultilingual.HSK-5-Chinese-Word-of-the-Day"))
    var vocabData: Data = Data()
    
    func placeholder(in context: Context) -> VocabEntry {
        
        let dummyVocab = ChineseVocab(Chinese: "快点把我打开！", Pinyin: "", Definition: "", Ex1: "", Trans1: "", Pinyin1: "", Ex2: "", Trans2: "", Pinyin2: "")
        
        return VocabEntry(vocab: dummyVocab)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (VocabEntry) -> Void) {
        
        guard let wordOfTheDay = try? JSONDecoder().decode(ChineseVocab.self, from: vocabData) else {                print("Unable to decode vocab for widget item.")
            return
        }
        //let chineseWord = wordOfTheDay.Chinese
        let entry = VocabEntry(vocab: wordOfTheDay)
        // entry.vocab.Chinese
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<VocabEntry>) -> Void) {
        
        guard let wordOfTheDay = try? JSONDecoder().decode(ChineseVocab.self, from: vocabData) else {return}
        let entry = VocabEntry(vocab: wordOfTheDay)
        
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
    
}

struct HSK5WidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        ZStack {
            GeometryReader { geometryProxy in
                Image("lantern")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
                    .clipped()
                
                //Image("majoing") // good for medium and large

            }
            
            VStack(alignment: .center) {
                
                Text(entry.vocab.Chinese)
                    .font(.title)
                    .bold()
                    .lineLimit(nil)
                    .foregroundColor(.white)
                
                Text(entry.vocab.Pinyin)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .foregroundColor(.white)
                
                Text(entry.vocab.Definition)
                    .font(.body)
                    .fontWeight(.semibold)
                    .lineLimit(nil)
                    .foregroundColor(.white)
                
            }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
    }
}

@main
struct HSK5Widget: Widget {
    let kind: String = "HSK5Widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            HSK5WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

//struct HSK5Widget_Previews: PreviewProvider {
//    static var previews: some View {
//
//
//        HSK5WidgetEntryView(entry: VocabEntry(vocab: vocabData))
//            .previewContext(WidgetPreviewContext(family: .systemSmall))
//    }
//}



