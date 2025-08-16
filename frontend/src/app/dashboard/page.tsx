import {
  TrendingUp,
  Users,
  BookOpen,
  Award,
  BarChart3,
  Calendar,
  Eye,
  Star,
} from "lucide-react";
import Navigation from "../../../components/Navigation";

export default function DashboardPage() {
  const mockStats = {
    totalEarnings: 1250,
    totalReaders: 89,
    publishedContent: 12,
    averageRating: 4.7,
    monthlyEarnings: [120, 180, 150, 200, 250, 300, 280],
    recentContent: [
      {
        id: 1,
        title: "Solidity Smart Contract Basics",
        views: 45,
        earnings: 180,
        rating: 4.8,
        publishedDate: "2024-01-15",
      },
      {
        id: 2,
        title: "Web3 Frontend with React",
        views: 32,
        earnings: 120,
        rating: 4.6,
        publishedDate: "2024-01-10",
      },
    ],
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />

      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <h1 className="text-3xl font-bold text-gray-900">
            Creator Dashboard
          </h1>
          <p className="text-gray-600 mt-2">
            Track your content performance and earnings
          </p>
        </div>
      </header>

      {/* Stats Overview */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center">
              <div className="p-2 bg-blue-100 rounded-lg">
                <Award className="w-6 h-6 text-blue-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">
                  Total Earnings
                </p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockStats.totalEarnings} KMT
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center">
              <div className="p-2 bg-green-100 rounded-lg">
                <Users className="w-6 h-6 text-green-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">
                  Total Readers
                </p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockStats.totalReaders}
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center">
              <div className="p-2 bg-purple-100 rounded-lg">
                <BookOpen className="w-6 h-6 text-purple-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">
                  Published Content
                </p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockStats.publishedContent}
                </p>
              </div>
            </div>
          </div>

          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center">
              <div className="p-2 bg-yellow-100 rounded-lg">
                <Star className="w-6 h-6 text-yellow-600" />
              </div>
              <div className="ml-4">
                <p className="text-sm font-medium text-gray-600">
                  Average Rating
                </p>
                <p className="text-2xl font-bold text-gray-900">
                  {mockStats.averageRating}
                </p>
              </div>
            </div>
          </div>
        </div>

        {/* Charts and Analytics */}
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 mb-8">
          {/* Earnings Chart */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-gray-900">
                Monthly Earnings
              </h3>
              <BarChart3 className="w-5 h-5 text-gray-400" />
            </div>
            <div className="h-64 flex items-end justify-between space-x-2">
              {mockStats.monthlyEarnings.map((earning, index) => (
                <div
                  key={index}
                  className="flex-1 bg-gradient-to-t from-blue-600 to-purple-600 rounded-t"
                  style={{ height: `${(earning / 300) * 100}%` }}
                ></div>
              ))}
            </div>
            <div className="flex justify-between text-xs text-gray-500 mt-2">
              <span>Jan</span>
              <span>Feb</span>
              <span>Mar</span>
              <span>Apr</span>
              <span>May</span>
              <span>Jun</span>
              <span>Jul</span>
            </div>
          </div>

          {/* Recent Activity */}
          <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
            <div className="flex items-center justify-between mb-6">
              <h3 className="text-lg font-medium text-gray-900">
                Recent Activity
              </h3>
              <Calendar className="w-5 h-5 text-gray-400" />
            </div>
            <div className="space-y-4">
              <div className="flex items-center p-3 bg-gray-50 rounded-lg">
                <div className="w-2 h-2 bg-green-500 rounded-full mr-3"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">
                    New reader on "Solidity Basics"
                  </p>
                  <p className="text-xs text-gray-500">2 hours ago</p>
                </div>
                <span className="text-sm font-medium text-green-600">
                  +5 KMT
                </span>
              </div>
              <div className="flex items-center p-3 bg-gray-50 rounded-lg">
                <div className="w-2 h-2 bg-blue-500 rounded-full mr-3"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">
                    Content rated 5 stars
                  </p>
                  <p className="text-xs text-gray-500">5 hours ago</p>
                </div>
                <span className="text-sm font-medium text-blue-600">
                  +2 KMT
                </span>
              </div>
              <div className="flex items-center p-3 bg-gray-50 rounded-lg">
                <div className="w-2 h-2 bg-purple-500 rounded-full mr-3"></div>
                <div className="flex-1">
                  <p className="text-sm font-medium text-gray-900">
                    New comment received
                  </p>
                  <p className="text-xs text-gray-500">1 day ago</p>
                </div>
                <span className="text-sm font-medium text-purple-600">
                  +1 KMT
                </span>
              </div>
            </div>
          </div>
        </div>

        {/* Content Performance */}
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-6">
          <h3 className="text-lg font-medium text-gray-900 mb-6">
            Content Performance
          </h3>
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Content
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Views
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Earnings
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Rating
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Published
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {mockStats.recentContent.map((content) => (
                  <tr key={content.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-gray-900">
                        {content.title}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center text-sm text-gray-900">
                        <Eye className="w-4 h-4 mr-1" />
                        {content.views}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="text-sm font-medium text-green-600">
                        {content.earnings} KMT
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div className="flex items-center text-sm text-gray-900">
                        <Star className="w-4 h-4 text-yellow-400 fill-current mr-1" />
                        {content.rating}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {content.publishedDate}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </div>

        {/* Quick Actions */}
        <div className="mt-8 grid grid-cols-1 md:grid-cols-3 gap-6">
          <button className="bg-gradient-to-r from-blue-600 to-purple-600 text-white p-6 rounded-lg hover:from-blue-700 hover:to-purple-700 transition-all duration-200">
            <div className="flex items-center justify-center mb-3">
              <BookOpen className="w-8 h-8" />
            </div>
            <h3 className="text-lg font-semibold mb-2">Publish New Content</h3>
            <p className="text-blue-100 text-sm">
              Share your knowledge and start earning
            </p>
          </button>

          <button className="bg-white border-2 border-gray-200 text-gray-700 p-6 rounded-lg hover:border-gray-300 hover:bg-gray-50 transition-all duration-200">
            <div className="flex items-center justify-center mb-3">
              <TrendingUp className="w-8 h-8" />
            </div>
            <h3 className="text-lg font-semibold mb-2">View Analytics</h3>
            <p className="text-gray-600 text-sm">
              Detailed insights and performance metrics
            </p>
          </button>

          <button className="bg-white border-2 border-gray-200 text-gray-700 p-6 rounded-lg hover:border-gray-300 hover:bg-gray-50 transition-all duration-200">
            <div className="flex items-center justify-center mb-3">
              <Award className="w-8 h-8" />
            </div>
            <h3 className="text-lg font-semibold mb-2">Claim Rewards</h3>
            <p className="text-gray-600 text-sm">
              Withdraw your earned KMT tokens
            </p>
          </button>
        </div>
      </div>
    </div>
  );
}
