-- Question 1: Achieving 1NF (First Normal Form)


-- Original table: ProductDetail
-- | OrderID | CustomerName | Products                  |
-- |---------|--------------|--------------------------|
-- | 101     | John Doe     | Laptop, Mouse            |
-- | 102     | Jane Smith   | Tablet, Keyboard, Mouse  |
-- | 103     | Emily Clark  | Phone                    |

-- SQL query to achieve 1NF:
-- We will use a UNION to normalize the 'Products' column into separate rows for each product.

SELECT OrderID, CustomerName, 'Laptop' AS Product
FROM ProductDetail
WHERE FIND_IN_SET('Laptop', Products) > 0

UNION ALL

SELECT OrderID, CustomerName, 'Mouse' AS Product
FROM ProductDetail
WHERE FIND_IN_SET('Mouse', Products) > 0

UNION ALL

SELECT OrderID, CustomerName, 'Tablet' AS Product
FROM ProductDetail
WHERE FIND_IN_SET('Tablet', Products) > 0

UNION ALL

SELECT OrderID, CustomerName, 'Keyboard' AS Product
FROM ProductDetail
WHERE FIND_IN_SET('Keyboard', Products) > 0

UNION ALL

SELECT OrderID, CustomerName, 'Phone' AS Product
FROM ProductDetail
WHERE FIND_IN_SET('Phone', Products) > 0;

-- This query transforms the table to 1NF by ensuring each row represents a single product for an order.

---

-- Question 2: Achieving 2NF (Second Normal Form)
-- The 'CustomerName' depends on 'OrderID', which is a partial dependency in the given table.
-- To achieve 2NF, we need to break the table into two: one for order information and one for product details.

-- Original table: OrderDetails
-- | OrderID | CustomerName  | Product   | Quantity |
-- |---------|---------------|-----------|----------|
-- | 101     | John Doe      | Laptop    | 2        |
-- | 101     | John Doe      | Mouse     | 1        |
-- | 102     | Jane Smith    | Tablet    | 3        |
-- | 102     | Jane Smith    | Keyboard  | 1        |
-- | 102     | Jane Smith    | Mouse     | 2        |
-- | 103     | Emily Clark   | Phone     | 1        |

-- SQL query to transform the table into 2NF by removing partial dependencies:

-- Step 1: Create a table to store order information (order ID and customer name)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL
);

-- Step 2: Insert the unique order information into the Orders table
INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create a table to store product details (order ID, product, quantity)
CREATE TABLE OrderProducts (
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 4: Insert the product details into the OrderProducts table
INSERT INTO OrderProducts (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;

