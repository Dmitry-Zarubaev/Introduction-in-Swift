//
//  Lesson_4.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 24.01.2022.
//

import Foundation


struct VehicleWeight {
    let curbWeight: Int
    let dryWeight: Int
    // Gross Vehicle Weight Rating
    let gvwr: Int
    
    init?(curbWeight: Int, dryWeight: Int, gvwr: Int) {
        if (gvwr > 0 && curbWeight > 0 && dryWeight > 0 && curbWeight > dryWeight && gvwr > curbWeight) {
            self.curbWeight = curbWeight
            self.dryWeight = dryWeight
            self.gvwr = gvwr
        } else {
            return nil
        }
    }
    
    public func getPayloadCapacity() -> Int {
        return gvwr - curbWeight
    }
}

struct CarFrame {
    let vin: String?
    let fuelTank: Int
    let weight: VehicleWeight
    let driveLayout: WheelDriveLayout
    let enginePosition: EnginePosition
    
    let seats: Int
    let maxSpeed: Int
    
    public func isValidVIN() -> Bool {
        if let vin = self.vin {
            // https://en.wikipedia.org/wiki/Vehicle_identification_number#Components
            return vin.count == 17
        } else {
            return false
        }
    }
}


enum CarAction {
    case Engine(act: EngineAction)
    case Fuel(volume: Int)
    case GlassWindows(act: GlassWindowAction)
    case Payload(act: PayloadAction)
}


class Car {
    var manufacturer: String?
    var model: String?
    var year: Int?
    let frame: CarFrame
    
    private var engine: Engine?

    private var isGlassWindowRaised: Bool = true
    private var isEngineStarted: Bool = false
    
    private var payload: Int = 0
    private var fuel: Int = 0
    
    public var isEngineReadyToStart: Bool {
        get {
            if let engine = self.engine {
                return engine.isValidEngine() && fuel > 0
            } else {
                return false
            }
        }
    }
    
    init(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine? = nil) {
        // <> using of IF here causing the 'constant '' used before being initialized' error
        self.model = model.isEmpty ? nil : model
        self.year = year >= 1886 ? year : nil // https://www.daimler.com/company/tradition/company-history/1885-1886.html
        self.manufacturer = manufacturer.isEmpty ? nil : manufacturer
        // </>

        self.frame = frame
        self.engine = engine
    }
    
    convenience init(who manufacturer: String, what model: String, frame: CarFrame, engine: Engine? = nil) {
        self.init(who: manufacturer, what: model, when: 0, frame: frame, engine: engine)
    }
    
    convenience init(when year: Int, frame: CarFrame, engine: Engine? = nil) {
        self.init(who: "", what: "", when: year, frame: frame, engine: engine)
    }
    
    convenience init(frame: CarFrame, engine: Engine? = nil) {
        self.init(who: "", what: "", when: 0, frame: frame, engine: engine)
    }
    
    convenience init(frame: CarFrame) {
        self.init(who: "", what: "", when: 0, frame: frame, engine: nil)
    }

    
    public func printState() -> Void {
        let occupation: String
        switch self.payload {
            case let x where x == frame.weight.getPayloadCapacity():
                occupation = "car is carrying the max payload"
            case let x where x == 0:
                occupation = "car isn't carrying any paylod"
            default:
                occupation = "current payload is \(payload)"
        }
        print("Glass windows are \(isGlassWindowRaised ? "raised" : "lowered"), the engine \(isEngineStarted ? "is working" : "turned off"), the \(occupation), in the tank \(fuel) liters of fuel.")
    }
    
    public func printInfo() -> Void {
        var introduction: String = ""
        
        introduction += "\(model == nil ? "This is an unknown model" : "\(model!) car") was made "
        introduction += "by \(manufacturer ?? "an unknown manufacturer") "
        introduction += year == nil ? "in unknown year." : "in \(year!)"
        
        let message = """
        \(introduction). Max payload capacity for this vehicle is \(frame.weight.getPayloadCapacity()) kg and gross weight is \(frame.weight.gvwr) kg.
        The engine placed in the \(frame.enginePosition.rawValue.lowercased()) of its body and the car has the \(frame.driveLayout.rawValue.lowercased()) wheel drive layout.
        About the car's engine. \(engine == nil ? "Right now it hasn't had any engine" : engine!.getInfo()).
        """
        print(message)
    }
    
    public func getShortName() -> String {
        if let manufacturer = self.manufacturer, let model = self.model, let year = self.year {
            return "\(manufacturer) \(model) of \(year)"
        } else if manufacturer == nil && model == nil && year == nil {
            return "A car"
        } else {
            var name: String = ""
            name += manufacturer ?? ""
            name += model == nil ? manufacturer == nil ? "A car" : "'s car" : " " + model!
            name += year == nil ? "" : " of \(year!)"
            return name + "."
        }
    }
    
    private func actWithEngine(action: EngineAction) -> Void {
        if let _ = self.engine {
            switch action {
                case .Start:
                    if isEngineReadyToStart {
                        print(isEngineStarted ? "The engine is already working!" : "The engine has started fine! Listen how it roars!")
                        isEngineStarted = true
                    } else {
                        print("This engine isn't ready to start")
                    }
                case .TurnOff:
                    print(isEngineStarted ? "The engine is turned off now!" : "The engine is already stopped and was cold for a long time!")
                    isEngineStarted = false
            }
        } else {
            print("This car doesn't have any engine inside!")
        }
    }
    
    private func actWithGlassWindow(action: GlassWindowAction) -> Void {
        switch action {
            case .Lower:
            print(isGlassWindowRaised ? "Glass windows have been lowered!" : "It's already lowered!")
                isGlassWindowRaised = false
            case .Raise:
            print(isGlassWindowRaised ? "It's already raised!" : "Glass windows have been raised!")
                isGlassWindowRaised = true
        }
    }
    
    private func actWithPayload(action: PayloadAction) -> Void {
        switch action {
            case .PlaceIn(let volume):
                if (payload + volume > frame.weight.getPayloadCapacity()) {
                    print("You can't place so much payload in this trunk! Take less on \(payload + volume - frame.weight.getPayloadCapacity()) kg.")
                } else if (volume <= 0) {
                    print("Are you kidding?!")
                } else {
                    payload += volume
                    print("Payload was placed with great care and accuracy.")
                }
            case .TakeFrom(let volume):
                if (payload - volume < 0) {
                    print("Hey! You're asking too much! Take your \(payload) kg of payload!")
                    payload = 0
                } else if (payload == 0) {
                    print("The trunk is empty. You can't take anything from it.")
                } else {
                    self.payload -= volume
                    print("Here is your payload, sir!")
                }
        }
    }
    
    private func fillFuelTank(volume: Int) -> Void {
        if volume < 0 {
            print("Something totally wrong here.")
        } else {
            if fuel + volume > frame.fuelTank {
                print("You're filling too much! The tank is full now and \(fuel + volume - frame.fuelTank) liters are redundant.")
            } else {
                fuel += volume
                print("Safe road to you!")
            }
        }
    }
    
    public func doCarAction(do action: CarAction) -> Void {
        switch action {
            case .Engine(let engineAct):
                actWithEngine(action: engineAct)
            case .GlassWindows(let windowsAct):
                actWithGlassWindow(action: windowsAct)
            case .Payload(let payloadAct):
                actWithPayload(action: payloadAct)
            case .Fuel(let volume):
                fillFuelTank(volume: volume)
        }
    }
}

class Forklift: Car {
    override init(who manufacturer: String, what model: String, when year: Int, frame: CarFrame, engine: Engine? = nil) {
        super.init(who: manufacturer, what: model, when: year, frame: frame, engine: engine)
    }
}

class Truck: Car {
    public var forklift: Car?
    
    override func printState() {
        super.printState()
        print(forklift == nil ? "Forklift is not provided." : "There is one forklift in our usage")
    }
    
    override func doCarAction(do action: CarAction) {
        switch action {
            case .Payload(_):
                if let _ = self.forklift {
                    super.doCarAction(do: action)
                } else {
                    print("You can't do it without a forklift at least!")
                }
            default:
                super.doCarAction(do: action)
        }
    }
}

class SportCar: Car {
    private let minSpeedForSportCar: Int = 225 // km/h
    private let minEnginePower: Int = 250 // hp
    private let maxSeatCount: Int = 2
    
    init?(who manufacturer: String, what model: String, when year: Int, sportFrame: CarFrame, engine: Engine) {
        super.init(who: manufacturer, what: model, when: year, frame: sportFrame, engine: engine)
        if (sportFrame.maxSpeed < minSpeedForSportCar || sportFrame.seats > maxSeatCount || engine.maxPower.power < minEnginePower) {return nil}
    }
}


// ------------------------------------------------------------------------------------------------------------------------------------------------------


func getCarActionFromUser() -> CarAction {
    let glassAction: () -> CarAction? = {
        let message: String = "Please, write what you want to do (\(GlassWindowAction.Raise.rawValue)/\(GlassWindowAction.Lower.rawValue)):"
        var action: CarAction?
        
        switch getStringFromUserIf(message: message, where: {s in s.lowercased() == GlassWindowAction.Raise.rawValue || s.lowercased() == GlassWindowAction.Lower.rawValue}) {
            case let x where x.lowercased() == GlassWindowAction.Raise.rawValue:
                action = CarAction.GlassWindows(act: GlassWindowAction.Raise)
            case let x where x.lowercased() == GlassWindowAction.Lower.rawValue:
                action = CarAction.GlassWindows(act: GlassWindowAction.Lower)
            default:
                print("How did you do it?!")
        }
        
        return action
    }
    
    let engineAction: () -> CarAction? = {
        let message: String = "Please, write what you want to do (\(EngineAction.Start.rawValue)/\(EngineAction.TurnOff.rawValue)):"
        var action: CarAction?
        
        switch getStringFromUserIf(message: message, where: {s in s.lowercased() == EngineAction.Start.rawValue || s.lowercased() == EngineAction.TurnOff.rawValue}) {
            case let x where x.lowercased() == EngineAction.Start.rawValue:
                action = CarAction.Engine(act: EngineAction.Start)
            case let x where x.lowercased() == EngineAction.TurnOff.rawValue:
                action = CarAction.Engine(act: EngineAction.TurnOff)
            default:
                print("How did you do it?!")
        }
        
        return action
    }
    
    let payloadAction: () -> CarAction = {
        let options: Array<(description: String, action: PayloadAction)> = [
            ("1. Take the payload from the trunk", .TakeFrom()),
            ("2. Place the payload into the trunk", .PlaceIn())
        ]
        
        var message: String = "Please, choose one of the follwing options:\n"
        for option in options {
            message += "\t\(option.description)\n"
        }
        
        let optionIndex = getIntFromUserIf(message: message, condition: {$0 > 0 && $0 <= options.count}) - 1
        var action: PayloadAction = options[optionIndex].action
        action.getValue()
        return CarAction.Payload(act: action)
    }
    
    let fuelAction: () -> CarAction = {
        let message: String = "Please, specify how much fuel do you want to fill in:"
        let fuelVolume: Int = getIntFromUserIf(message: message, condition: {$0 > 0})
        
        return CarAction.Fuel(volume: fuelVolume)
    }
    
    let actions: Array<(description: String, action: () -> CarAction?)> = [
        ("1. Action with the glass windows", glassAction),
        ("2. Action with the engine", engineAction),
        ("3. Action with the trunk", payloadAction),
        ("4. Action with the fuel tank", fuelAction)
    ]
    var iterMessage: String = "\nPlease, choose one of the action below:\n"
    for action in actions {
        iterMessage += "\t\(action.description)\n"
    }

    
    let actionIndex: Int = getIntFromUserIf(message: iterMessage, condition: {input in input > 0 && input <= actions.count})
    
    return actions[actionIndex - 1].action()!
}

func handleCars() -> Void {
    print("We are going to handling with some vehicles of different types!")

    let porscheEngine: Engine = Engine(engineNumber: "741490", gasType: .Gasoline, ignitionType: .SparkIgnition, combustionChamberVolume: 3996, cylinders: 6, cylinderConfig: .Opposed, maxPower: (510, 8400), maxTorque: (470, 6100))
    let porscheWeight: VehicleWeight = VehicleWeight(curbWeight: 1418, dryWeight: 1358, gvwr: 1765)!
    let porscheFrame: CarFrame = CarFrame(vin: "WP0ZZZ95ZJN100108", fuelTank: 64, weight: porscheWeight, driveLayout: .Rear, enginePosition: .Rear, seats: 2, maxSpeed: 320)
    // https://auto.ru/catalog/cars/porsche/911_gt3/22776686/22776768/specifications/
    let porsche911GT3: SportCar = SportCar(who: "Porsche", what: "911 GT3 (992 body)", when: 2021, sportFrame: porscheFrame, engine: porscheEngine)!
    
    // https://avto-russia.ru/autos/freightliner/freightliner_business_class_m2_106_6-7_mt.html
    let freightlinerEngine: Engine = Engine(engineNumber: "5043_7001", gasType: .Diesel, ignitionType: .Diesel, combustionChamberVolume: 6700, cylinders: 6, cylinderConfig: .Straight, maxPower: (power: 200, rpm: 2600), maxTorque: (torque: 705, rpm: 1500))
    let freightlinerWeight: VehicleWeight = VehicleWeight(curbWeight: 6000, dryWeight: 5600, gvwr: 12000)!
    let freightlinerFrame: CarFrame = CarFrame(vin: "1FVACWDTSEHFH4589", fuelTank: 250, weight: freightlinerWeight, driveLayout: .Rear, enginePosition: .Front, seats: 2, maxSpeed: 120)
    let freightlinerM2106: Truck = Truck(who: "Freightliner", what: "M2 106", when: 2002, frame: freightlinerFrame, engine: freightlinerEngine)
    
    
    let porscheHandling: () -> Void = {
        let porschePrimeActions: Array<(description: String, task: () -> Void)> = [
            ("1. Perform an action with the Porsche", {porsche911GT3.doCarAction(do: getCarActionFromUser())}),
            ("2. Get info.", porsche911GT3.printInfo),
            ("3. Get status.", porsche911GT3.printState)
        ]
        
        actionsPresentation(welcome: "\nPlease, choose one of the actions below:", stopIs: "back", actions: porschePrimeActions)
    }
    
    
    let freightlinerHandling: () -> Void = {
        let forkliftAction: () -> Void = {
            if let _ = freightlinerM2106.forklift {
                print("The truck already has a forklift! What for one more?")
            } else {
                let forkliftEngine: Engine = Engine(engineNumber: "-", gasType: .Gasoline, ignitionType: .SparkIgnition, combustionChamberVolume: 2488, cylinders: 4, cylinderConfig: .Straight, maxPower: (power: 50, rpm: 2300), maxTorque: (torque: 171, rpm: 1600))
                let forkliftWeight: VehicleWeight = VehicleWeight(curbWeight: 3450, dryWeight: 3300, gvwr: 5450)!
                let forkliftFrame: CarFrame = CarFrame(vin: nil, fuelTank: 60, weight: forkliftWeight, driveLayout: .All, enginePosition: .Rear, seats: 1, maxSpeed: 20)
                let forklift: Forklift = Forklift(who: "Maximal", what: "2T LPG", when: 2011, frame: forkliftFrame, engine: forkliftEngine)
                freightlinerM2106.forklift = forklift
                print("Now we have a forklift in our usage!")
            }
        }
        
        let freightlinerPrimeActions: Array<(description: String, task: () -> Void)> = [
            ("1. Perform an action with the car", {freightlinerM2106.doCarAction(do: getCarActionFromUser())}),
            ("2. Provide a forklifter", forkliftAction),
            ("3. Get info.", freightlinerM2106.printInfo),
            ("4. Get status.", freightlinerM2106.printState)
        ]
        
        actionsPresentation(welcome: "\nPlease, choose one of the actions below:", stopIs: "back", actions: freightlinerPrimeActions)
    }

    let handlingActions: Array<(description: String, task: () -> Void)> = [
        ("1. \(porsche911GT3.getShortName())", porscheHandling),
        ("2. \(freightlinerM2106.getShortName())", freightlinerHandling)
    ]
    
    actionsPresentation(welcome: "\nPlease, choose one of the following vehicles below:", stopIs: "back", actions: handlingActions)
}

let lesson4: Array<(String, () -> Void)> = [
    ("1. All six tasks in one handling of different cars", handleCars)
]
