import SwiftUI

struct ContentView: View {
    @State private var selectedPairs: Int = 3
    @State private var cards: [Card] = []
    //predefined emojis
    @State private var cardEmojies = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯"]
    //flippedcards array with card struct to track current flipped cards
    @State private var flippedCards: [Card] = []
    
    
    // card struct to give card attributes
    struct Card: Identifiable {
        let id = UUID()
        var isFlipped: Bool = false
        let pairId: Int // match pairs
        let emoji: String // emoji to display
    }
    
    var body: some View {
        VStack {
            HStack {
                Menu {
                    Button("3 Pairs") {
                        selectedPairs = 3
                        setupCards()
                    }
                    Button("6 Pairs") {
                        selectedPairs = 6
                        setupCards()
                    }
                    Button("10 Pairs") {
                        selectedPairs = 10
                        setupCards()
                    }
                } label: {
                    Text("Choose Size")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                Spacer()
                Button("Reset Game") {
                    setupCards()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            
            ScrollView {
                let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(cards) { card in
                        CardView(card: card) {
                            flipCard(card)
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            setupCards()
        }
    }
    
    //function to reset flipped through button
    func resetFlippedCards(){
        for flippedCard in flippedCards {
            if let index = cards.firstIndex(where: { $0.id == flippedCard.id }) {
                cards[index].isFlipped = false
            }
        }
        flippedCards.removeAll()
    }
    
    // sets up pairs for the cards and emojis
    func setupCards() {
        var newCards: [Card] = []
        for i in 0..<selectedPairs {
            newCards.append(Card(pairId: i, emoji: cardEmojies[i]))
            newCards.append(Card(pairId: i, emoji: cardEmojies[i]))
        }
        cards = newCards.shuffled()     }
    
    // function to flip cards and check for matches
    func flipCard(_ cardToFlip: Card) {
        if cardToFlip.isFlipped {
            return
        }
        if let index = cards.firstIndex(where: { $0.id == cardToFlip.id }) {
                cards[index].isFlipped = true
                flippedCards.append(cards[index])
                
                // Check for matches when 2 cards are flipped
                if flippedCards.count == 2 {
                    if flippedCards[0].pairId == flippedCards[1].pairId {
                        // Match! Clear flippedCards but keep them flipped
                        flippedCards.removeAll()
                    } else {
                        // Not a match, flip them back after delay
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            resetFlippedCards()
                        }
                    }
                }
            }
        }
}
    

// view of card
struct CardView: View {
    let card: ContentView.Card
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(card.isFlipped ? Color(red: 0.6, green: 0.8, blue: 1.0) : Color.blue)
                .frame(height: 100)
                .cornerRadius(8)
            
            if card.isFlipped {
                Text(card.emoji)
                    .font(.system(size: 50))
            }
        }
        .onTapGesture {
            onTap()
        }
    }
}
