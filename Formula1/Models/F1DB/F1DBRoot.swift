import Foundation

struct F1DBRoot: Decodable {
    let drivers: [F1DBDriver]
    let constructors: [F1DBConstructor]
    let engineManufacturers: [F1DBEngineManufacturer]
    let tyreManufacturers: [F1DBTyreManufacturer]
    let entrants: [F1DBEntrant]
    let circuits: [F1DBCircuit]
    let grandsPrix: [F1DBGrandPrix]
    let seasons: [F1DBSeason]
    let races: [F1DBRace]
    let continents: [F1DBContinent]
    let countries: [F1DBCountry]
}
