#import only nesscary columns
$csvFile = './2020budget.csv'

$file = Import-Csv $csvFile | Select-Object -Property Month,Amount,Category,Type
#import category list
$categories = Import-Csv $csvFile | select -ExpandProperty Category | Sort-Object -unique
#import months
$months = Import-Csv $csvFile | select-Object -ExpandProperty Month | Sort-Object -unique

#loop through each month
ForEach($month in $months){
    $expense = 0
    $fun = 0
    #init each month a seperate csv
    $m = $file | where-Object {$_.Month -eq $month}
    #write the month to the screen
    Write-Host "-" $month "-"
    #loop through each
    $total = 0
    ForEach($category in $categories){
        #get the sum of the category
        $fun = $m | Where-Object {$_.Type -eq "Fun"} | Select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        $expense = $m | Where-Object {$_.Type -eq "Expense"} | Select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        $income = $m | Where-Object {$_.Type -eq ""} | Select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        $sum = $m | where-Object {$_.Category -eq $category} | select-Object -ExpandProperty Amount | Measure-Object -Sum | Select-Object -ExpandProperty Sum
        #write the category and its sum to the screen
        $total = $total + $sum
        Write-Host $category $sum
    }
    $savings =  [Math]::round($income + $expense + $fun)
    $total = [math]::round($total,2)
    $funT = $fun
    $fun =[Math]::Abs($fun)/$income
    $expenseT = $expense
    $expense = [Math]::Abs($expense)/$income
    
    Write-host "Monthly Total:" $total
    Write-host "Fun:", $fun.tostring("P"), " Expense: ",$expense.tostring("P"), " Savings: ", $savings
    Write-host "Fun:", $funT, " Expense: ", $expenseT
    Write-host ""
    $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
#Write-Host "Press any key to continue..."
#cat$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")