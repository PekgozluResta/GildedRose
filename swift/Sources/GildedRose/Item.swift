public class Item {
    public var name: String
    public var sellIn: Int
    public var quality: Int
    
    public init(name: String, sellIn: Int, quality: Int) {
        self.name = name
        self.sellIn = sellIn
        self.quality = quality
    }
}

extension Item: CustomStringConvertible {
    public var description: String {
        return self.name + ", " + String(self.sellIn) + ", " + String(self.quality);
    }
}

extension Item {
   private var minimumSellIn: Int { 0 }
   private var minimumQuality: Int { 0 }
   private var maximumQuality: Int { 50 }
   private var increasingRate: Int { 1 }
   private var depreciatingRate: Int { -1 }
   private var depreciatingRateFast: Int { -2 }
   private var depreciatingFactorConjured: Int { 2 }
    
   private enum ItemQualityType {
       case depreciating, depreciatingConjured, increasing, increasingExponentially, fixed
   }

   private var qualityType: ItemQualityType {
       switch self.name{
       case "Aged Brie": return .increasing
       case "Backstage passes to a TAFKAL80ETC concert": return .increasingExponentially
       case "Sulfuras, Hand of Ragnaros": return .fixed
       case "Conjured Mana Cake": return .depreciatingConjured
       default: return .depreciating }
   }
   
   private func rateOfDepreciation(conjured:Bool)-> Int {
       let depreciating = sellIn < minimumSellIn ? depreciatingRateFast : depreciatingRate
       return conjured ? depreciating * depreciatingFactorConjured : depreciating
   }
       
   private func rateOfIncrease(exponentially:Bool)-> Int {
       let increaseInfos:[(limit:Int, rate:Int)] = [( minimumSellIn, rate: -1 * quality),(5, 3),(10, 2)]
       var increasingExponentially = increasingRate
       
       for increaseInfo in increaseInfos {
           if sellIn <= increaseInfo.limit {
               increasingExponentially =  increaseInfo.rate
               break
           }
       }
       return exponentially ? increasingExponentially : increasingRate
   }
       
   public func update(){
       sellIn -= 1
       
       switch qualityType {
       case .depreciating:
           quality += rateOfDepreciation(conjured: false)
       case .depreciatingConjured:
           quality += rateOfDepreciation(conjured: true)
       case .increasing:
           quality += rateOfIncrease(exponentially: false)
       case .increasingExponentially:
           quality += rateOfIncrease(exponentially: true)
       case .fixed: break}
              
       if quality > maximumQuality && qualityType != .fixed { quality = maximumQuality }
       if sellIn < minimumSellIn { sellIn = minimumSellIn }
       if quality < minimumQuality { quality = minimumQuality }
   }
}
