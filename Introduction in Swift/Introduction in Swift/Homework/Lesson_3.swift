//
//  Lesson_3.swift
//  Introduction in Swift
//
//  Created by Дмитрий Зарубаев on 18.01.2022.
//

import Foundation

enum GlassWindowAction: String {
    case Raise = "raise"
    case Lower = "lower"
}

enum EngineAction: String {
    case Start = "start"
    case TurnOff = "turn off"
}

enum LuggageAction {
    case PlaceIn(volume: Int = 0)
    case TakeFrom(volume: Int = 0)
    
    mutating func getValue() {
        let value = getIntFromUserIf(message: "Please, specify the value of the luggage:", condition: {$0 > 0})
        switch self {
        case .PlaceIn(_):
            self = .PlaceIn(volume: value)
        case .TakeFrom(_):
            self = .TakeFrom(volume: value)
        }
    }
}



enum WheelDriveLayout: String {
    case Front
    case Rear
    case All
}

enum IgnitionType: String {
    case Diesel = "Diesel ignition"
    case SparkIgnition = "Spark ignition"
}

enum EngineGasType: String {
    case Diesel
    case Gasoline
    case CNG // Compressed Natural Gas
}

enum EnginePosition: String {
    case Front
    case Mid
    case Rear
}

enum CylinderConfiguration: String {
    case Straight
    case V
    case Opposed
    case W
    case Radial
}

struct Engine {
    let gasType: EngineGasType
    let ignitionType: IgnitionType
    let combustionChamberVolume: Int // qubicle centimeters
    let cylinders: Int
    let cylinderConfig: CylinderConfiguration
    
    let maxPower: (power: Int, rpm: Int) // Forse power at RPM
    let maxTorque: (torque: Int, rpm: Int) // H*m at RPM
    
    public func getInfo(returnIt: Bool) -> String {
        """
        It is \(gasType.rawValue.lowercased()) engine with \(ignitionType.rawValue.lowercased()).
        It have \(cylinders) \(cylinderConfig.rawValue.lowercased()) cylinders with total volume of \(combustionChamberVolume) qubicle cantimeters"
        The engine's max power is \(maxPower.power) hp at \(maxPower.rpm) rpm and its max torque is \(maxTorque.torque) at \(maxTorque.rpm) rpm
        """
    }
}

struct TruckVehicle {
    
}

struct SportCar {
    let manufacturer: String
    let model: String
    let year: Int
    let trunkVolume: Int // In liters
    let enginePosition: EnginePosition
    let driveLayout: WheelDriveLayout
    let engine: Engine
    
    private var isGlassWindowRaised: Bool = true
    private var isEngineStarted: Bool = false
    private var trunkOccupation: Int = 0
    
    init(manufacturer: String, model: String, year: Int, trunkVolume: Int, driveLayout: WheelDriveLayout, enginePosition: EnginePosition, engine: Engine) {
        self.manufacturer = manufacturer
        self.model = model
        self.year = year
        self.trunkVolume = trunkVolume
        self.enginePosition = enginePosition
        self.driveLayout = driveLayout
        self.engine = engine
    }
    
    public func printInfo() -> Void {
        let message = """
        \(model) car was made by \(manufacturer) in \(year). Its trunk has volume of \(trunkVolume) liters.
        The engine placed in the \(enginePosition.rawValue.lowercased()) of its body and the car has the \(driveLayout.rawValue.lowercased()) wheel drive layout.
        About the car's engine. \(engine.getInfo(returnIt: true)).
        """
        print(message)
    }
    
    public mutating func printState() -> Void {
        let occupation: String
        switch self.trunkOccupation {
            case let x where x == trunkVolume:
                occupation = "trunk is full"
            case let x where x == 0:
                occupation = "trunk is empty"
            default:
                occupation = "trunk has luggage of volume in \(self.trunkOccupation) liters"
        }
        print("Glass windows are \(isGlassWindowRaised ? "raised" : "lowered"), the engine \(isEngineStarted ? "is working" : "turned off"), the \(occupation).")
    }
    
    public mutating func actWithGlassWindow(action: GlassWindowAction) -> Void {
        switch action {
            case .Lower:
            print(isGlassWindowRaised ? "Glass windows have been lowered!" : "It's already lowered!")
                isGlassWindowRaised = false
            case .Raise:
            print(isGlassWindowRaised ? "It's already raised!" : "Glass windows have been raised!")
                isGlassWindowRaised = true
        }
    }
    
    public mutating func actWithEngine(action: EngineAction) -> Void {
        switch action {
            case .Start:
                print(isEngineStarted ? "The engine is already working!" : "The engine has started fine! Listen how it roars!")
                isEngineStarted = true
            case .TurnOff:
                print(isEngineStarted ? "The engine is turned off now!" : "The engine is already stopped and was cold for a long time!")
                isEngineStarted = false
        }
    }
    
    public mutating func getIntoTrunk(action: LuggageAction) {
        switch action {
            case .PlaceIn(let volume):
                if (trunkOccupation + volume > trunkVolume) {
                    print("You can't place so much luggage in this trunk! Take less on \(trunkOccupation + volume - trunkVolume) litres.")
                } else if (volume <= 0) {
                    print("Are you kidding?!")
                } else {
                    trunkOccupation += volume
                    print("Your luggage in the trunk now.")
                }
            case .TakeFrom(let volume):
                if (trunkOccupation - volume < 0) {
                    print("Hey! You're asking too much! Take your \(trunkOccupation) litres of luggage and get out of here!")
                    trunkOccupation = 0
                } else if (trunkOccupation == 0) {
                    print("The trunk is empty. You can't take anything from it.")
                } else {
                    self.trunkOccupation -= volume
                    print("Here is your luggage, sir!")
                }
        }
    }
    
}

func handleSportCar() -> Void {
    print("We are going to hanging over with a nice sport car!")
    
    var isHandling: Bool = true
    
    // https://auto.ru/catalog/cars/porsche/911_gt3/22776686/22776768/specifications/
    let porsheEngine: Engine = Engine(gasType: .Gasoline, ignitionType: .SparkIgnition, combustionChamberVolume: 3996, cylinders: 6, cylinderConfig: .Opposed, maxPower: (510, 8400), maxTorque: (470, 6100))
    var porshe911GT3: SportCar = SportCar(manufacturer: "Porshe", model: "911 GT3 (992 body)", year: 2021, trunkVolume: 132, driveLayout: .Rear, enginePosition: .Rear, engine: porsheEngine)
    
    let glassAction: () -> Void = {
        let message: String = "Please, write what you want to do (\(GlassWindowAction.Raise.rawValue)/\(GlassWindowAction.Lower.rawValue)):"
        
        switch getStringFromUserIf(message: message, where: {s in s.lowercased() == GlassWindowAction.Raise.rawValue || s.lowercased() == GlassWindowAction.Lower.rawValue}) {
            case let x where x.lowercased() == GlassWindowAction.Raise.rawValue:
                porshe911GT3.actWithGlassWindow(action: .Raise)
            case let x where x.lowercased() == GlassWindowAction.Lower.rawValue:
                porshe911GT3.actWithGlassWindow(action: .Lower)
            default:
                print("How did you do it?!")
        }
    }
    
    let engineAction: () -> Void = {
        let message: String = "Please, write what you want to do (\(EngineAction.Start.rawValue)/\(EngineAction.TurnOff.rawValue)):"
        
        switch getStringFromUserIf(message: message, where: {s in s.lowercased() == EngineAction.Start.rawValue || s.lowercased() == EngineAction.TurnOff.rawValue}) {
            case let x where x.lowercased() == EngineAction.Start.rawValue:
                porshe911GT3.actWithEngine(action: .Start)
            case let x where x.lowercased() == EngineAction.TurnOff.rawValue:
                porshe911GT3.actWithEngine(action: .TurnOff)
            default:
                print("How did you do it?!")
        }
    }
    
    let luggageAction: () -> Void = {
        let options: Array<(description: String, action: LuggageAction)> = [
            ("1. Take the luggage from the trunk", .TakeFrom()),
            ("2. Place the luggae into the trunk", .PlaceIn())
        ]

        var message: String = "Please, choose one of the follwing options:\n"
        for option in options {
            message += "\t\(option.description)\n"
        }
        
        let optionIndex = getIntFromUserIf(message: message, condition: {$0 > 0 && $0 <= options.count}) - 1
        var action: LuggageAction = options[optionIndex].action
        action.getValue()
        porshe911GT3.getIntoTrunk(action: action)
    }
    
    let actions: Array<(description: String, action: () -> Void)> = [
        ("1. Action with the glass windows", glassAction),
        ("2. Action with the engine", engineAction),
        ("3. Action with the trunk", luggageAction),
        ("4. Get car's info", porshe911GT3.printInfo),
        ("5. Get car's state", {porshe911GT3.printState()}),
        ("6. Exit", {isHandling = false})
    ]
    var iterMessage: String = "\nPlease, choose one of the action below:\n"
    for action in actions {
        iterMessage += "\t\(action.description)\n"
    }
    

    while isHandling {
        let actionIndex: Int = getIntFromUserIf(message: iterMessage, condition: {input in input > 0 && input <= actions.count})
        let currentAction: () -> Void = actions[actionIndex - 1].action
        
        currentAction()
    }
}

let lesson3: Array<(String, () -> Void)> = [
    ("1. All six tasks in one handling of a sport car", handleSportCar)
]
