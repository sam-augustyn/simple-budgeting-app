#import only nesscary columns
$csvFile = './2020budget.csv'

$file = Import-Csv $csvFile | Select-Object -Property Month,Amount,Category,Type #import category list
$categories = Import-Csv $csvFile | select -ExpandProperty Category | Sort-Object -unique #pull all of the categories
$months = Import-Csv $csvFile | select-Object -ExpandProperty Month | Sort-Object -unique #pull all of the months


ForEach($month in $months){ #loop through each month
    $expense = 0 #set the "expense counter" -> this is how much you have spent on expenses
    $fun = 0 #set the "fun counter" -> this is how much you have spent on items not categorized as expenses or income
    $m = $file | where-Object {$_.Month -eq $month} #pull data for certain months
    Write-Host "-" $month "-" #write the month to the screen
    $total = 0 #set the total -> this tells you if you are postive or negative for a month
    ForEach($category in $categories){ #loop through each category
        $fun = $m | Where-Object {$_.Type -eq "Fun"} | Select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum #pull the total of fun for the month
        $expense = $m | Where-Object {$_.Type -eq "Expense"} | Select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum #pull the total of expense for the month
        $income = $m | Where-Object {$_.Type -eq ""} | Select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum #pull all of the income for the month
        $sum = $m | where-Object {$_.Category -eq $category} | select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum #sum is the total for each category that month
        $total = $total + $sum #add to total to for the month
        Write-Host $category $sum #write the category and its sum to the screen
    }

    $savings = [Math]::round($income + $expense + $fun) #money "leftover" -> This could go to savings
    $total = [math]::round($total,2) #print the total 
    $funT = $fun #get the fun total amount
    $fun =[Math]::Abs($fun)/$income #get the percentage spent that month
    $expenseT = $expense #get the expense total
    $expense = [Math]::Abs($expense)/$income #get the percentage spent on expenses that month
    
    Write-host "Monthly Total:" $total #print the monthly total (unspent money)
    Write-host "Fun:", $fun.tostring("P"), " Expense: ",$expense.tostring("P"), " Savings: ", $savings #write the percentages
    Write-host "Fun:", $funT, " Expense: ", $expenseT #write the totals
    Write-host ""
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") #pause between each month
}
#Write-Host "Press any key to continue..."
#cat$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")