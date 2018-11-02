# Park Every Car (PVC)
### Team Members
<ul>
	<li>Animesh Bohara - 160050040</li>
	<li>Eashan Gupta - 160050045</li>
	<li>Ankit - 160050046</li>
	<li>Anmol Singh - 160050107</li>
</ul>

## Introduction
We plan to make an automated car parking ticketing system. We want to implement a new application for users to make payments for using a parking site by paying through an online wallet. We plan to make the ticketing system faster and efficient by automating it.

## Role and Interface of Users
### General Users
<ul>
	<li>They can own various number of cars (registered with the app), which they can use to enter the parking malls.</li>
	<li>At the entrance of the parking mall, they can go to the "Park your car" tab in the app, scan a QR code at the entrance. The vehicle number of the car will be scanned at the entrance and stored. After scanning, money will start getting deducted from the user’s wallet, and he will be shown the floor to park on.</li>
	<li>The amount present in the wallet will be displayed on the dashboard.</li>
	<li>They can browse through their registered cars and choose to pay for an already checked-in car from the list. After doing this, money will start getting deducted from their wallet. This will allow friends to pay for each other.</li>
	<li>There would be a button to register a new car with the user, using the car ID and password.</li>
	<li>While leaving the parking mall, the mall will scan the car number at exit, and stop charging the user.</li>
	<li>After a long time, every hour and in case of low balance, the user will be notified.</li>
</ul>

### Parking Mall Owner
<ul>
	<li>The owner will have a wallet which will show how much money he has earned.</li>
	<li>He will be shown a list of parking malls owned by him, details about them (number of free spots, price, revenue generated etc), and an option to change any of its prices.</li>
	<li>The owner will also be able to view the current state of each parking mall owned and see the number of cars parked.</li>
</ul>

### Parking Police
<ul>
	<li>The parking police is another set of users to control crimes.</li>
	<li>Each car will have a QR code which they can scan to get the uid and view the details of the owners of the car and the current user which checked in the car along with other details.</li>
</ul>

## ER Diagram
## Table Design

## Testing
To test the given implementation, we will test it by creating data for all different types of users and by using the app simultaneously to edit various things. We will also try by creating new data for it.

## References
<ol>
	<li>QR Scanner using Flutter - https://medium.com/@alfianlosari/building-flutter-qr-code-generator-scanner-and-sharing-app-703e73b228d3</li>
</ol>