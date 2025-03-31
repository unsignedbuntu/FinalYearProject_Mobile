class FaqItem {
  final String question;
  final String content;

  FaqItem({required this.question, required this.content});
}

class ServiceItem {
  final String title;
  final String content;

  ServiceItem({required this.title, required this.content});
}

class ResourceItem {
  final String title;
  final String content;

  ResourceItem({required this.title, required this.content});
}

// Static data
final List<FaqItem> faqItems = [
  FaqItem(
    question: "How to place an order?",
    content:
        "To place an order, simply browse our products, add items to your cart, and proceed to checkout. Select your preferred payment method and shipping address. Need more help? Check our detailed ordering guide.",
  ),
  FaqItem(
    question: "Shipping & Delivery",
    content:
        "We offer worldwide shipping with tracking. Standard delivery takes 3-5 business days, while express delivery takes 1-2 business days. International shipping may vary. Track your order using your order number.",
  ),
  FaqItem(
    question: "Returns & Refunds",
    content:
        "Not satisfied? Return items within 30 days of delivery for a full refund. Items must be unused and in original packaging. Contact our support team to initiate a return. Refunds are processed within 5-7 business days.",
  ),
  FaqItem(
    question: "Payment Methods",
    content:
        "We accept all major credit cards (Visa, MasterCard), PayPal, and bank transfers. All transactions are secure and encrypted. Having payment issues? Our support team is here to help.",
  ),
];

final List<ServiceItem> serviceItems = [
  ServiceItem(
    title: "Contact Support",
    content:
        "Get in touch with our 24/7 support team via email, phone, or live chat. Average response time: 2 hours.",
  ),
  ServiceItem(
    title: "Track Your Order",
    content:
        "Enter your order number to get real-time updates on your shipment status and estimated delivery date.",
  ),
  ServiceItem(
    title: "Report an Issue",
    content:
        "Experiencing problems? Submit a detailed report and our team will investigate and resolve it within 24 hours.",
  ),
  ServiceItem(
    title: "Request Callback",
    content:
        "Prefer to talk? Schedule a callback at your convenient time, and our support team will reach out to you.",
  ),
];

final List<ResourceItem> resourceItems = [
  ResourceItem(
    title: "User Guides",
    content:
        "Step-by-step guides on using our platform, placing orders, and managing your account.",
  ),
  ResourceItem(
    title: "Video Tutorials",
    content:
        "Watch our helpful video guides covering common questions and platform features.",
  ),
  ResourceItem(
    title: "Community Forum",
    content:
        "Join our community to discuss products, share experiences, and get tips from other users.",
  ),
  ResourceItem(
    title: "Knowledge Base",
    content:
        "Browse our extensive collection of articles, tutorials, and FAQs for instant answers.",
  ),
];
