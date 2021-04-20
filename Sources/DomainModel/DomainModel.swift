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
        var newAmount = Double(self.amount)
        if self.currency == currency {
            return self
        }
        
        if self.currency == "GBP" {
            newAmount = newAmount * 2
        } else if self.currency == "EUR" {
            newAmount = newAmount / 1.5
        } else if self.currency == "CAN" {
            newAmount = newAmount / 1.25
        }

        if currency == "GBP" {
            newAmount = newAmount / 2
        } else if currency == "EUR" {
            newAmount = (3 * newAmount) / 2
        } else if currency == "CAN" {
            newAmount = (5 * newAmount) / 4
        }
                
        return Money(amount: Int(newAmount), currency: currency)
    }
    
    func add(_ amount : Money) -> Money {
        var convertedAmount = amount
        print("adding amount", amount.amount, amount.currency)
        print("this amount", self.amount, self.currency)
        if amount.currency != self.currency {
            //convert
            convertedAmount = self.convert(amount.currency)
            print("converted amount to add: ", convertedAmount.amount, convertedAmount.currency)
        }
        
        let newAmount = amount.amount + convertedAmount.amount
        print("added amount: ", newAmount)
        return Money(amount: newAmount, currency: amount.currency)
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
    init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
        
        members.append(spouse2)
        members.append(spouse1)
        print("num members: ", members.count)
    }
    
    func haveChild(_ kid: Person) -> Bool{
        if members.count > 1 {
            if members[0].age > 21 || members[1].age > 21 {
                members.append(kid)
                return true
            }
        }
        return false
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0
        for i in 0...members.count - 1 {
            let currMember = members[i]
            if currMember.job != nil {
                print("job income: ", currMember.job?.calculateIncome(2000))
                totalIncome += (currMember.job?.calculateIncome(2000))!
            }
        }
        return totalIncome
    }
}

