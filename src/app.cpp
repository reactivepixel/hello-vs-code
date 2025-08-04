#include <iostream>
#include <string>
#include <vector>
#include <cmath>

class Shape
{
protected:
    std::string color; // Encapsulation: protected attribute
public:
    Shape(const std::string &color) : color(color) {}
    virtual ~Shape() = default;               // Virtual destructor for proper cleanup
    virtual double calculateArea() const = 0; // Abstraction: pure virtual function
    virtual void draw() const
    {
        std::cout << "Drawing a " << color << " shape." << std::endl;
    }
};

class Circle : public Shape
{
protected:
    double radius; // Encapsulation: protected data
public:
    Circle(double radius, const std::string &color) : Shape(color), radius(radius) {}
    double calculateArea() const override
    {
        return M_PI * radius * radius; // Polymorphism: specific implementation
    }
};

class Rectangle : public Shape
{
protected:
    double width, height;

public:
    Rectangle(double width, double height, const std::string &color)
        : Shape(color), width(width), height(height) {}
    double calculateArea() const override
    {
        return width * height; // Inheritance: specialized behavior
    }
};

int main()
{
    std::vector<Shape *> shapes;
    shapes.push_back(new Circle(5.0, "red"));
    shapes.push_back(new Rectangle(4.0, 6.0, "blue"));

    for (const auto *shape : shapes)
    {
        std::cout << "Area: " << shape->calculateArea() << std::endl;
        shape->draw();
    }

    // Clean up to prevent memory leaks
    for (auto *shape : shapes)
    {
        delete shape;
    }
    return 0;
}