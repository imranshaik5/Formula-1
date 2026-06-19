import Foundation

struct TriviaQuestion: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let options: [String]
    let correctIndex: Int
    let funFact: String
}

extension TriviaQuestion {
    static let all: [TriviaQuestion] = [
        TriviaQuestion(
            question: "Who has the most Formula 1 World Drivers' Championships?",
            options: ["Michael Schumacher", "Lewis Hamilton", "Juan Manuel Fangio", "Max Verstappen"],
            correctIndex: 1,
            funFact: "Lewis Hamilton and Michael Schumacher both hold 7 titles, but Hamilton has the most race wins (103+)."
        ),
        TriviaQuestion(
            question: "Which team has won the most Constructors' Championships?",
            options: ["Ferrari", "Williams", "McLaren", "Mercedes"],
            correctIndex: 0,
            funFact: "Ferrari holds the record with 16 Constructors' Championships, their last coming in 2008."
        ),
        TriviaQuestion(
            question: "What is the fastest lap in F1 history?",
            options: ["Valtteri Bottas", "Lewis Hamilton", "Juan Pablo Montoya", "Michael Schumacher"],
            correctIndex: 0,
            funFact: "Valtteri Bottas set the fastest lap in F1 history at the 2018 Italian GP with an average speed of 263.587 km/h."
        ),
        TriviaQuestion(
            question: "Which circuit hosts the Monaco Grand Prix?",
            options: ["Circuit de Monaco", "Circuit de la Sarthe", "Circuit de Barcelona-Catalunya", "Circuit de Spa-Francorchamps"],
            correctIndex: 0,
            funFact: "The Monaco GP has been held on the streets of Monte Carlo since 1929 and is considered the crown jewel of F1."
        ),
        TriviaQuestion(
            question: "Who was the youngest driver to win a Formula 1 World Championship?",
            options: ["Sebastian Vettel", "Lewis Hamilton", "Max Verstappen", "Fernando Alonso"],
            correctIndex: 2,
            funFact: "Max Verstappen won his first title at 24 years old in 2021, making him the youngest champion in F1 history."
        ),
        TriviaQuestion(
            question: "How many points is a Grand Prix win worth under the current points system?",
            options: ["25", "20", "30", "10"],
            correctIndex: 0,
            funFact: "The current system awards 25 points for 1st, 18 for 2nd, and 15 for 3rd, down to 1 point for 10th."
        ),
        TriviaQuestion(
            question: "Which driver has the most pole positions in F1 history?",
            options: ["Ayrton Senna", "Michael Schumacher", "Lewis Hamilton", "Max Verstappen"],
            correctIndex: 2,
            funFact: "Lewis Hamilton holds the record with 104 pole positions, far ahead of Michael Schumacher's 68."
        ),
        TriviaQuestion(
            question: "What year was the first Formula 1 World Championship held?",
            options: ["1946", "1950", "1955", "1948"],
            correctIndex: 1,
            funFact: "The first official F1 World Championship season was in 1950, won by Giuseppe Farina driving for Alfa Romeo."
        ),
        TriviaQuestion(
            question: "Which engine manufacturer has won the most F1 races?",
            options: ["Ferrari", "Mercedes", "Ford Cosworth", "Honda"],
            correctIndex: 1,
            funFact: "Mercedes holds the record for most F1 race wins by an engine manufacturer with over 200 victories."
        ),
        TriviaQuestion(
            question: "What is the longest circuit on the current F1 calendar?",
            options: ["Spa-Francorchamps", "Silverstone", "Suzuka", "Circuit of the Americas"],
            correctIndex: 0,
            funFact: "Spa-Francorchamps in Belgium is the longest circuit at 7.004 km, famous for Eau Rouge and the challenging Ardennes weather."
        ),
        TriviaQuestion(
            question: "Who is the only driver to win championships with three different teams?",
            options: ["Jackie Stewart", "Niki Lauda", "Juan Manuel Fangio", "Alain Prost"],
            correctIndex: 2,
            funFact: "Fangio won titles with Alfa Romeo, Maserati, Mercedes, and Ferrari — four different teams."
        ),
        TriviaQuestion(
            question: "What is the DRS (Drag Reduction System)?",
            options: ["A brake system", "A movable rear wing", "A tire compound", "A fuel system"],
            correctIndex: 1,
            funFact: "DRS opens a flap on the rear wing to reduce drag, giving a speed boost of about 10-12 km/h when activated."
        ),
        TriviaQuestion(
            question: "Which country has hosted the most F1 Grands Prix?",
            options: ["Italy", "United Kingdom", "Germany", "United States"],
            correctIndex: 0,
            funFact: "Italy has hosted the most F1 races, primarily at Monza which has been on the calendar since 1950."
        ),
        TriviaQuestion(
            question: "Who was the first Black driver to compete in Formula 1?",
            options: ["Lewis Hamilton", "Willy T. Ribbs", "Alexander Wurz", "Pedro Rodríguez"],
            correctIndex: 1,
            funFact: "Willy T. Ribbs tested for Brabham in 1986 but never raced. Lewis Hamilton was the first Black driver to start an F1 race."
        ),
        TriviaQuestion(
            question: "What does the black and white flag mean in F1?",
            options: ["Race finished", "Final lap", "Unsportsmanlike conduct warning", "Disqualification"],
            correctIndex: 2,
            funFact: "The black and white flag is shown to warn a driver for unsportsmanlike behavior — a second offense brings a black flag."
        ),
        TriviaQuestion(
            question: "Which driver has the nickname 'The Iceman'?",
            options: ["Mika Häkkinen", "Kimi Räikkönen", "Valtteri Bottas", "Niki Lauda"],
            correctIndex: 1,
            funFact: "Kimi Räikkönen earned 'The Iceman' nickname for his cool, emotionless demeanor and his 2007 World Championship."
        ),
        TriviaQuestion(
            question: "What is the minimum weight of a Formula 1 car in 2026?",
            options: ["698 kg", "768 kg", "800 kg", "650 kg"],
            correctIndex: 1,
            funFact: "The 2026 regulations increased the minimum weight to 768 kg, up from 798 kg in 2024, due to new power unit regulations."
        ),
        TriviaQuestion(
            question: "Which team did Michael Schumacher drive for when he won his first championship?",
            options: ["Ferrari", "Benetton", "McLaren", "Williams"],
            correctIndex: 1,
            funFact: "Schumacher won back-to-back titles with Benetton in 1994 and 1995 before moving to Ferrari."
        ),
        TriviaQuestion(
            question: "What is the name of the final corner at the Yas Marina Circuit?",
            options: ["Hairpin", "Overtake", "Mario", "West"],
            correctIndex: 0,
            funFact: "The final corner at Abu Dhabi is simply called 'Hairpin' and leads onto the pit straight where the 2021 season finale drama unfolded."
        ),
        TriviaQuestion(
            question: "Which driver has scored the most points in a single season?",
            options: ["Lewis Hamilton", "Max Verstappen", "Sebastian Vettel", "Michael Schumacher"],
            correctIndex: 1,
            funFact: "Max Verstappen scored 575 points in the 2023 season, breaking his own record set in 2022."
        ),
        TriviaQuestion(
            question: "What does the acronym 'ERS' stand for in F1?",
            options: ["Engine Racing System", "Energy Recovery System", "Electronic Racing Setup", "Engine Rev System"],
            correctIndex: 1,
            funFact: "ERS recovers energy from braking and exhaust heat, storing it in batteries for an extra 160 hp boost per lap."
        ),
        TriviaQuestion(
            question: "Which Grand Prix is known as 'The Temple of Speed'?",
            options: ["Monza", "Silverstone", "Suzuka", "Monaco"],
            correctIndex: 0,
            funFact: "Monza, home of the Italian GP, earned 'Temple of Speed' for its high-speed layout where cars regularly exceed 350 km/h."
        ),
        TriviaQuestion(
            question: "Who is the most successful female F1 driver?",
            options: ["Maria Teresa de Filippis", "Lella Lombardi", "Divina Galica", "Desiré Wilson"],
            correctIndex: 1,
            funFact: "Lella Lombardi is the only woman to score points in F1, finishing 6th at the 1975 Spanish GP (earning 0.5 points)."
        ),
        TriviaQuestion(
            question: "What material are modern F1 brake discs made from?",
            options: ["Steel", "Carbon fiber", "Carbon-ceramic", "Titanium"],
            correctIndex: 2,
            funFact: "F1 cars use carbon-ceramic brake discs that can reach 1000°C and decelerate from 300 km/h to 100 km/h in under 2 seconds."
        ),
        TriviaQuestion(
            question: "Which driver has the most consecutive race wins in a single season?",
            options: ["Michael Schumacher", "Sebastian Vettel", "Max Verstappen", "Alberto Ascari"],
            correctIndex: 2,
            funFact: "Max Verstappen won 10 consecutive races in 2023 (Miami to Monza), breaking the record of 9 set by Alberto Ascari in 1952-53."
        ),
        TriviaQuestion(
            question: "What is the 'Parade Lap'?",
            options: ["The formation lap before the race", "A victory lap", "A practice start", "A pit exit lap"],
            correctIndex: 0,
            funFact: "The parade/formation lap lets drivers warm tires, check systems, and do practice starts before the race begins."
        ),
        TriviaQuestion(
            question: "Which team is the most successful in F1 history?",
            options: ["Mercedes", "McLaren", "Ferrari", "Williams"],
            correctIndex: 2,
            funFact: "Ferrari is the most successful team with 15 Drivers' and 16 Constructors' Championships, and over 240 race wins."
        ),
        TriviaQuestion(
            question: "What does the abbreviation 'MGU-K' stand for?",
            options: ["Motor Generator Unit - Kinetic", "Master Gear Unit - KERS", "Motorized Gear Unit - Kinetic", "Main Generator Unit - KERS"],
            correctIndex: 0,
            funFact: "MGU-K recovers kinetic energy from braking and converts it to electricity stored in the battery, providing a 120 kW boost."
        ),
        TriviaQuestion(
            question: "Which race has been held the most times in F1 history?",
            options: ["Italian GP", "British GP", "Monaco GP", "German GP"],
            correctIndex: 0,
            funFact: "The Italian GP has been held 93 times, followed by the British GP (76) and Monaco GP (70+)."
        ),
        TriviaQuestion(
            question: "Who was the last driver to win a championship with a V10 engine?",
            options: ["Fernando Alonso", "Michael Schumacher", "Kimi Räikkönen", "Juan Pablo Montoya"],
            correctIndex: 2,
            funFact: "Kimi Räikkönen won the 2007 title with Ferrari's V8, but the last V10 champion was Michael Schumacher in 2004."
        ),
    ]
}
