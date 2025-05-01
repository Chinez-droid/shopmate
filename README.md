# 🛍️ Shop With Friends - Mobile Developer Assessment (Flutter)
This is a coding assessment for mobile developers applying to work on
real-time collaborative features in a Flutter application. The
project simulates a feature that allows users to invite a friend and
shop together via a shared cart experience.
—
## 🎯 Objective
Implement the **Shop With Friends** flow using Flutter. A user should
be able to:
- Create a shopping session and invite a friend via a link
- The friend joins the session, temporarily enters a shared cart
state
- Both users can add items to the cart, which syncs in real-time or
via simulation
- Once done, the friend exits the shared state, and the original user
continues
---
## 🏢 Project Structure
```bash
/lib
    /models
        cart_item.dart
        product.dart
        session.dart
    /providers
        cart_provider.dart
        session_provider.dart
    /routes
        app_router.dart
        app_router.gr.dart
    /screens
        cart_invite_screen.dart
        confirmation_screen.dart
        home_screen.dart
        invite_landing_page.dart
        product_list_screen.dart
        shared_cart_screen.dart
    /services
        firebase_service.dart
    /utils
        constants.dart
    /widgets
        animations_widget.dart
        custom_widgets.dart
        responsive_widget.dart
    firebase_options.dart
    main.dart
```
---
## ⚒️ Setup Instructions
To get started with Shopmate, follow these steps:
1. Clone the repository:
   ```bash
   git clone https://github.com/Chinez-droid/shopmate.git
   cd shopmate
2. Install dependencies:
   ```bash
   flutter pub get
3. Run the application:
   ```bash
   flutter run
---
## 🧭 Explanation of routing and state management choice
For routing, I implemented `auto_route` based on several technical considerations:
- It provides code generation for type-safe routing, which significantly reduced development time and potential navigation-related bugs.
- The framework's support for nested navigation structures allowed for more sophisticated user flows, particularly when implementing product detail hierarchies.
- Its declarative approach to route definition aligns well with Flutter's architecture and improved the maintainability of navigation logic throughout development cycles.

For state management, I selected `Provider` after evaluating several alternatives:
- It offers an optimal balance between simplicity and functionality, with a clean integration pattern that follows Flutter's component architecture.
- The solution provides efficient state propagation with minimal boilerplate, resulting in more maintainable code and reduced complexity.
- Its widespread adoption in the Flutter ecosystem ensured access to established patterns and extensive documentation, facilitating both implementation and knowledge transfer within development teams.
---
## 🧵 Fake data source explanation
I used the `faker` package because it:
- Enabled realistic mock data generation for products, users, and cart items, allowing me to build and test the UI .
- Helped simulate a variety of test cases—such as multiple users adding items to a shared cart, or products with long names and prices.
- Allowed me to iterate quickly and preview different UI states (empty cart, full cart, shared view) across development and demo stages.

## 🔎 Limitations or assumptions made
For limitations, I identified several implementation constraints:
- Firebase Implementation Scope: The current Firebase integration prioritizes real-time cart synchronization functionality. Implementing additional features such as comprehensive user authentication flows, cross-device session persistence, and robust analytics tracking would require extending the current architecture.
- Device Compatibility Parameters: The application has been optimized specifically for portrait orientation on standard mobile form factors, with responsive testing conducted on mainstream device dimensions. Deployment to tablet environments or devices with non-standard aspect ratios may necessitate further UI refinement and performance validation.
- Network Dependency: The application architecture requires consistent network connectivity to facilitate Firebase data synchronization and remote asset loading. A comprehensive offline operation mode with local data persistence has not been implemented, potentially affecting usability in environments with unreliable connectivity.

For assumptions, I based my implementation on several key premises:
- User Interaction Patterns: The interface design operates on the premise that users will intuitively comprehend the shared cart functionality through established UI conventions, without requiring extensive tutorial or onboarding sequences. The interaction model assumes familiarity with standard e-commerce interface paradigms.
- Data Stability Requirements: The current implementation assumes relative stability in product data attributes throughout user sessions. The system is not designed to handle real-time product information updates, inventory availability changes, or dynamic pricing adjustments that would be present in production environments.
- Temporal Session Constraints: The architecture has been designed with the assumption of temporally limited shopping sessions. Comprehensive handling of extended cart persistence and long-duration session management across multiple days falls outside the current implementation scope.

## 🌟 Suggestions for improvement/scaling
For future enhancements, I would prioritize these strategic improvements:
- Advanced Authentication: Integration of Firebase Authentication would establish a more robust user identity framework, enabling persistent user profiles with personalized shopping experiences. This would support cross-session cart retention, purchase history tracking, and preference management, significantly enhancing the application's utility for returning users.
- Real Product Data Implementation: Transitioning from mock data to integration with established e-commerce APIs (such as Shopify, WooCommerce, or specialized product information services) would transform the application's commercial viability. This enhancement would introduce accurate product information, real-time inventory status, and high-resolution product imagery, substantially improving the authenticity of the shopping experience.
- Theme Adaptation Capability: Development of comprehensive light and dark mode functionality would address both user preference and accessibility requirements. This implementation would require establishing distinct theme-based color systems, adapting UI components for theme-responsive rendering, and creating persistent theme selection mechanisms to maintain consistent user experience across sessions.
