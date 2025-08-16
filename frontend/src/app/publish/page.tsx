import { Upload, FileText, Tag, DollarSign, Eye } from "lucide-react";
import Navigation from "../../../components/Navigation";

export default function PublishPage() {
  return (
    <div className="min-h-screen bg-gray-50">
      <Navigation />

      {/* Header */}
      <header className="bg-white border-b border-gray-200">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <h1 className="text-3xl font-bold text-gray-900">Publish Content</h1>
          <p className="text-gray-600 mt-2">
            Share your knowledge and earn rewards
          </p>
        </div>
      </header>

      {/* Main Form */}
      <div className="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        <div className="bg-white rounded-lg shadow-sm border border-gray-200 p-8">
          <form className="space-y-6">
            {/* Content Title */}
            <div>
              <label
                htmlFor="title"
                className="block text-sm font-medium text-gray-700 mb-2"
              >
                Content Title *
              </label>
              <input
                type="text"
                id="title"
                name="title"
                placeholder="Enter a compelling title for your content"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                required
              />
            </div>

            {/* Content Description */}
            <div>
              <label
                htmlFor="description"
                className="block text-sm font-medium text-gray-700 mb-2"
              >
                Description *
              </label>
              <textarea
                id="description"
                name="description"
                rows={4}
                placeholder="Provide a clear description of what readers will learn"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                required
              />
            </div>

            {/* Category Selection */}
            <div>
              <label
                htmlFor="category"
                className="block text-sm font-medium text-gray-700 mb-2"
              >
                Category *
              </label>
              <select
                id="category"
                name="category"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                required
              >
                <option value="">Select a category</option>
                <option value="blockchain">Blockchain & Web3</option>
                <option value="frontend">Frontend Development</option>
                <option value="backend">Backend Development</option>
                <option value="defi">DeFi & Finance</option>
                <option value="security">Security</option>
                <option value="tutorials">Tutorials & How-tos</option>
                <option value="research">Research & Analysis</option>
                <option value="other">Other</option>
              </select>
            </div>

            {/* Tags */}
            <div>
              <label
                htmlFor="tags"
                className="block text-sm font-medium text-gray-700 mb-2"
              >
                Tags
              </label>
              <input
                type="text"
                id="tags"
                name="tags"
                placeholder="Enter tags separated by commas (e.g., solidity, smart-contracts, ethereum)"
                className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              <p className="text-sm text-gray-500 mt-1">
                Tags help readers discover your content
              </p>
            </div>

            {/* Content File Upload */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Content File *
              </label>
              <div className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center hover:border-gray-400 transition-colors">
                <Upload className="mx-auto h-12 w-12 text-gray-400 mb-4" />
                <div className="text-sm text-gray-600">
                  <label
                    htmlFor="file-upload"
                    className="relative cursor-pointer bg-white rounded-md font-medium text-blue-600 hover:text-blue-500"
                  >
                    <span>Upload a file</span>
                    <input
                      id="file-upload"
                      name="file-upload"
                      type="file"
                      className="sr-only"
                      accept=".md,.txt,.pdf,.doc,.docx"
                    />
                  </label>
                  <p className="pl-1">or drag and drop</p>
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  PDF, Markdown, or Word documents up to 10MB
                </p>
              </div>
            </div>

            {/* Content Preview */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Content Preview
              </label>
              <div className="border border-gray-300 rounded-lg p-4 bg-gray-50">
                <div className="flex items-center gap-2 text-sm text-gray-600 mb-2">
                  <FileText className="w-4 h-4" />
                  <span>Preview will be generated from your uploaded file</span>
                </div>
                <div className="text-sm text-gray-500">
                  Content preview helps readers understand what they'll learn
                  before starting
                </div>
              </div>
            </div>

            {/* Reward Settings */}
            <div className="border-t border-gray-200 pt-6">
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Reward Settings
              </h3>

              <div className="grid md:grid-cols-2 gap-6">
                <div>
                  <label
                    htmlFor="baseReward"
                    className="block text-sm font-medium text-gray-700 mb-2"
                  >
                    Base Reward (KMT) *
                  </label>
                  <div className="relative">
                    <input
                      type="number"
                      id="baseReward"
                      name="baseReward"
                      min="1"
                      max="1000"
                      placeholder="50"
                      className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                      required
                    />
                    <DollarSign className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
                  </div>
                  <p className="text-sm text-gray-500 mt-1">
                    Base reward per reader (1-1000 KMT)
                  </p>
                </div>

                <div>
                  <label
                    htmlFor="qualityBonus"
                    className="block text-sm font-medium text-gray-700 mb-2"
                  >
                    Quality Bonus Multiplier
                  </label>
                  <select
                    id="qualityBonus"
                    name="qualityBonus"
                    className="w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                  >
                    <option value="1.0">1.0x (No bonus)</option>
                    <option value="1.2">1.2x (20% bonus)</option>
                    <option value="1.5">1.5x (50% bonus)</option>
                    <option value="2.0">2.0x (100% bonus)</option>
                  </select>
                  <p className="text-sm text-gray-500 mt-1">
                    Bonus for high-quality content
                  </p>
                </div>
              </div>
            </div>

            {/* Publishing Options */}
            <div className="border-t border-gray-200 pt-6">
              <h3 className="text-lg font-medium text-gray-900 mb-4">
                Publishing Options
              </h3>

              <div className="space-y-4">
                <div className="flex items-center">
                  <input
                    type="checkbox"
                    id="public"
                    name="public"
                    className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                    defaultChecked
                  />
                  <label
                    htmlFor="public"
                    className="ml-2 block text-sm text-gray-900"
                  >
                    Make content public (visible to all users)
                  </label>
                </div>

                <div className="flex items-center">
                  <input
                    type="checkbox"
                    id="allowComments"
                    name="allowComments"
                    className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                    defaultChecked
                  />
                  <label
                    htmlFor="allowComments"
                    className="ml-2 block text-sm text-gray-900"
                  >
                    Allow reader comments and questions
                  </label>
                </div>

                <div className="flex items-center">
                  <input
                    type="checkbox"
                    id="featured"
                    name="featured"
                    className="h-4 w-4 text-blue-600 focus:ring-blue-500 border-gray-300 rounded"
                  />
                  <label
                    htmlFor="featured"
                    className="ml-2 block text-sm text-gray-900"
                  >
                    Submit for featured content consideration
                  </label>
                </div>
              </div>
            </div>

            {/* Submit Button */}
            <div className="border-t border-gray-200 pt-6">
              <button
                type="submit"
                className="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-3 px-6 rounded-lg font-semibold hover:from-blue-700 hover:to-purple-700 transition-all duration-200 flex items-center justify-center gap-2"
              >
                <Eye className="w-5 h-5" />
                Publish Content
              </button>
              <p className="text-sm text-gray-500 text-center mt-2">
                Your content will be reviewed and published within 24 hours
              </p>
            </div>
          </form>
        </div>
      </div>
    </div>
  );
}
