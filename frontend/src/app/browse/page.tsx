import { Search, Filter, BookOpen, Clock, Eye, Star } from "lucide-react";
import Navigation from "../components/Navigation";

export default function BrowsePage() {
  const mockContent = [
    {
      id: 1,
      title: "Complete Solidity Smart Contract Development",
      author: "Alice Crypto",
      description:
        "Learn to build, test, and deploy smart contracts on Ethereum and Monad blockchain",
      category: "Blockchain",
      readTime: "45 min",
      views: 1234,
      rating: 4.8,
      reward: "50 KMT",
    },
    {
      id: 2,
      title: "Web3 Frontend Development with React",
      author: "Bob Developer",
      description:
        "Build modern Web3 applications using React, Wagmi, and RainbowKit",
      category: "Frontend",
      readTime: "30 min",
      views: 856,
      rating: 4.6,
      reward: "35 KMT",
    },
    {
      id: 3,
      title: "DeFi Protocol Design Patterns",
      author: "Carol Finance",
      description:
        "Understanding the architecture and security patterns in DeFi protocols",
      category: "DeFi",
      readTime: "60 min",
      views: 2100,
      rating: 4.9,
      reward: "75 KMT",
    },
  ];

  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />

      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <h1 className="text-3xl font-bold text-gray-900">Browse Knowledge</h1>
          <p className="text-gray-600 mt-2">
            Discover educational content and earn rewards
          </p>
        </div>
      </header>

      {/* Search and Filters */}
      <div className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="flex-1 relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
              <input
                type="text"
                placeholder="Search for topics, authors, or content..."
                className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
            </div>
            <button className="flex items-center gap-2 px-4 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
              <Filter className="w-5 h-5" />
              Filters
            </button>
          </div>

          {/* Category Pills */}
          <div className="flex flex-wrap gap-2 mt-4">
            {[
              "All",
              "Blockchain",
              "Frontend",
              "DeFi",
              "Security",
              "Tutorials",
            ].map((category) => (
              <button
                key={category}
                className={`px-4 py-2 rounded-full text-sm font-medium transition-colors ${
                  category === "All"
                    ? "bg-blue-600 text-white"
                    : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                }`}
              >
                {category}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Content Grid */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6">
          {mockContent.map((content) => (
            <div
              key={content.id}
              className="bg-white rounded-lg shadow-sm border border-gray-200 hover:shadow-md transition-shadow"
            >
              <div className="p-6">
                <div className="flex items-center gap-2 mb-3">
                  <span className="px-2 py-1 bg-blue-100 text-blue-800 text-xs font-medium rounded-full">
                    {content.category}
                  </span>
                  <span className="text-sm text-gray-500">
                    {content.author}
                  </span>
                </div>

                <h3 className="text-lg font-semibold text-gray-900 mb-2 line-clamp-2">
                  {content.title}
                </h3>

                <p className="text-gray-600 text-sm mb-4 line-clamp-3">
                  {content.description}
                </p>

                <div className="flex items-center justify-between text-sm text-gray-500 mb-4">
                  <div className="flex items-center gap-4">
                    <div className="flex items-center gap-1">
                      <Clock className="w-4 h-4" />
                      {content.readTime}
                    </div>
                    <div className="flex items-center gap-1">
                      <Eye className="w-4 h-4" />
                      {content.views}
                    </div>
                  </div>
                  <div className="flex items-center gap-1">
                    <Star className="w-4 h-4 text-yellow-400 fill-current" />
                    {content.rating}
                  </div>
                </div>

                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <BookOpen className="w-4 h-4 text-blue-600" />
                    <span className="text-sm font-medium text-blue-600">
                      {content.reward}
                    </span>
                  </div>
                  <a
                    href={`/content/${content.id}`}
                    className="px-4 py-3 bg-blue-600 text-white text-sm font-medium rounded-lg hover:bg-blue-700 transition-colors inline-block text-center"
                  >
                    Start Reading
                  </a>
                </div>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
