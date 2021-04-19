struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    func convert(_ currency : String) -> Money {
        // check the current currency type
        // normalize all types of currency on USD
        // then convert from USD to another type
        var newAmount = Int()
        
        if currency == "GBP" {
            newAmount = self.amount * 2
        } else if self.currency == "EUR" {
            newAmount = self.amount * 1
        } else if self.currency == "CAN" {
            newAmount = self.amount * 1
        }
        
        return Money(amount: newAmount, currency: currency)
    }
    
    func add(_ amount : Money) -> Money {
        var convertedAmount = amount.amount
        if amount.currency != self.currency {
            //convert
            convertedAmount = amount.convert(self.currency).amount
        }
        
        let newAmount = self.amount + convertedAmount
        return Money(amount: newAmount, currency: self.currency)
    }
    
    func subtract(_ amount : Money) -> Money {
        let negativeMoney = Money(amount: amount.amount * -1, currency: amount.currency)
        return add(negativeMoney)
    }
}

////////////////////////////////////
// Job
//

//init(fromFahrenheit fahrenheit: Double) {
//    temperatureInCelsius = (fahrenheit - 32.0) / 1.8
//}

public class Job {
    var title : String
    var type : JobType
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    init(title ti: String, type ty: JobType) {
        title = ti
        type = ty
    }
    
    func calculateIncome(_ hours : Int) -> Int {
        switch self.type {
        case .Hourly(let wage):
            return Int(wage) * hours
        case .Salary(let salary):
            print("salary: ", Int(salary))
            return Int(salary)
        }
    }
    
    func raise(byAmount: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = JobType.Hourly(byAmount + wage)
        case .Salary(let salary):
            self.type = JobType.Salary(UInt(byAmount + Double(salary)))
            print("new salary wage: ", self.type)
        }
    }
    
    func raise(byPercent: Double) {
        switch self.type {
        case .Hourly(let wage):
            self.type = JobType.Hourly(byPercent * wage + wage)
        case .Salary(let salary):
            self.type = JobType.Salary(UInt(byPercent * Double(salary) + Double(salary)))
            print("new salary wage: ", self.type)
        }
    }
    
}



////////////////////////////////////
// Person
//
public class Person {
    let firstName: String
    let lastName: String
    let age: Int
    var job: Job? = nil {
        didSet(newVal) {
            if age < 21 {
                job = nil
            }
        }
    }
    
    var spouse: Person? = nil{
        didSet(newVal) {
            if age < 21 || spouse!.age < 21 {
                spouse = nil
            }
        }
    }
    
    init(firstName fn: String, lastName ln: String, age a: Int) {
        firstName = fn
        lastName = ln
        age = a
    }
    
    public func toString() -> String {
        return String("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]")
    }
}


////////////////////////////////////
// Family
//
public class Family {
    var members: [Person] = []
    init(spouse1 sp1: Person, spouse2 sp2: Person) {
        if sp1.spouse == nil && sp2.spouse == nil {
            sp1.spouse = sp2
            sp2.spouse = sp1
        }
        members.append(sp1)
        members.append(sp2)
    }
    func haveChild(_ kid: Person) -> Bool{
        return true
    }
    func householdIncome() -> Int {

        return 0
    }
}

