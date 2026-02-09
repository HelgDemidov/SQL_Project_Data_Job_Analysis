import React, { useState } from 'react';
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Cell, ScatterChart, Scatter, ZAxis, ComposedChart, Line } from 'recharts';

const jobShareData = [
  { title: "Data Engineer", postings: 21261, share: 30.545, color: "#0EA5E9" },
  { title: "Data Scientist", postings: 14534, share: 20.880, color: "#6366F1" },
  { title: "Data Analyst", postings: 13331, share: 19.152, color: "#8B5CF6" },
  { title: "Sr. Data Engineer", postings: 6564, share: 9.430, color: "#06B6D4" },
  { title: "Sr. Data Scientist", postings: 3809, share: 5.472, color: "#A855F7" },
  { title: "Software Engineer", postings: 2918, share: 4.192, color: "#EC4899" },
  { title: "Business Analyst", postings: 2786, share: 4.003, color: "#F43F5E" },
  { title: "Sr. Data Analyst", postings: 2352, share: 3.379, color: "#F97316" },
  { title: "ML Engineer", postings: 1480, share: 2.126, color: "#EAB308" },
  { title: "Cloud Engineer", postings: 571, share: 0.820, color: "#22C55E" }
];

const skillsDemandData = [
  { skill: "SQL", jobs: 142062, share: 61.4, type: "Programming" },
  { skill: "Python", jobs: 137245, share: 59.3, type: "Programming" },
  { skill: "AWS", jobs: 81578, share: 35.3, type: "Cloud" },
  { skill: "Azure", jobs: 77054, share: 33.3, type: "Cloud" },
  { skill: "Spark", jobs: 69905, share: 30.2, type: "Libraries" },
  { skill: "Java", jobs: 45814, share: 19.8, type: "Programming" },
  { skill: "Kafka", jobs: 38890, share: 16.8, type: "Libraries" },
  { skill: "Scala", jobs: 37453, share: 16.2, type: "Programming" },
  { skill: "Hadoop", jobs: 36762, share: 15.9, type: "Libraries" },
  { skill: "Snowflake", jobs: 35821, share: 15.5, type: "Cloud" }
];

const skillsSalaryData = [
  { skill: "Mongo", count: 239, avgSalary: 176119, medianSalary: 173500 },
  { skill: "Cassandra", count: 432, avgSalary: 156724, medianSalary: 156596 },
  { skill: "Shell", count: 569, avgSalary: 149303, medianSalary: 150000 },
  { skill: "Angular", count: 54, avgSalary: 146583, medianSalary: 147500 },
  { skill: "Redis", count: 76, avgSalary: 143495, medianSalary: 147500 },
  { skill: "Kafka", count: 1319, avgSalary: 147097, medianSalary: 147500 },
  { skill: "MySQL", count: 612, avgSalary: 145363, medianSalary: 147500 },
  { skill: "PyTorch", count: 64, avgSalary: 141784, medianSalary: 147500 },
  { skill: "Redshift", count: 1176, avgSalary: 145249, medianSalary: 147500 },
  { skill: "Scala", count: 1222, avgSalary: 146949, medianSalary: 147500 }
];

const optimalSkillsData = [
  { skill: "Python", demand: 4196, salary: 135000, rank: 1 },
  { skill: "SQL", demand: 4289, salary: 131580, rank: 2 },
  { skill: "AWS", demand: 2887, salary: 140000, rank: 3 },
  { skill: "Spark", demand: 2297, salary: 145000, rank: 4 },
  { skill: "Azure", demand: 2059, salary: 132500, rank: 5 },
  { skill: "Java", demand: 1656, salary: 144482, rank: 6 },
  { skill: "Snowflake", demand: 1571, salary: 143000, rank: 7 },
  { skill: "Kafka", demand: 1319, salary: 147500, rank: 8 },
  { skill: "Scala", demand: 1222, salary: 147500, rank: 9 },
  { skill: "Hadoop", demand: 1226, salary: 145000, rank: 10 }
];

const topPayingJobsData = [
  { company: "Engtal", salary: 325 },
  { company: "Durlston Partners", salary: 300 },
  { company: "Twitch", salary: 251 },
  { company: "Signify Technology", salary: 250 },
  { company: "AI Startup", salary: 250 },
  { company: "Movable Ink", salary: 245 },
  { company: "Handshake", salary: 245 },
  { company: "Meta", salary: 242 }
];

function App() {
  const [activeTab, setActiveTab] = useState('overview');

  const tabs = [
    { id: 'overview', label: '📊 Market Overview' },
    { id: 'demand', label: '🔥 Skills Demand' },
    { id: 'salary', label: '💰 Salary Analysis' },
    { id: 'optimal', label: '🎯 Optimal Skills' },
    { id: 'top', label: '🚀 Top Paying' }
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-800 to-slate-900 text-white p-4 md:p-6">
      {/* Header */}
      <div className="text-center mb-6">
        <h1 className="text-2xl md:text-3xl font-bold bg-gradient-to-r from-cyan-400 via-blue-500 to-purple-500 bg-clip-text text-transparent mb-2">
          Data Engineer Job Market Analysis
        </h1>
        <p className="text-slate-400 text-sm">231,000+ job postings analyzed • SQL Portfolio Project</p>
        <a 
          href="https://github.com/HelgDemidov/SQL_Project_Data_Job_Analysis" 
          target="_blank" 
          rel="noopener noreferrer"
          className="inline-block mt-2 text-xs text-cyan-400 hover:text-cyan-300 transition-colors"
        >
          View on GitHub →
        </a>
      </div>

      {/* Tabs */}
      <div className="flex flex-wrap justify-center gap-2 mb-6">
        {tabs.map(tab => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`px-3 py-2 rounded-lg text-xs md:text-sm font-medium transition-all ${
              activeTab === tab.id 
                ? 'bg-gradient-to-r from-cyan-500 to-blue-500 text-white shadow-lg shadow-cyan-500/25' 
                : 'bg-slate-700/50 text-slate-300 hover:bg-slate-700'
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Content */}
      <div className="max-w-4xl mx-auto">
        
        {/* Overview Tab */}
        {activeTab === 'overview' && (
          <div className="space-y-4">
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h2 className="text-lg font-semibold mb-4">Remote Data Job Postings by Role</h2>
              <ResponsiveContainer width="100%" height={350}>
                <BarChart data={jobShareData} layout="vertical" margin={{ left: 0, right: 20 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(148,163,184,0.1)" />
                  <XAxis type="number" stroke="#64748B" tickFormatter={(v) => v.toLocaleString()} fontSize={11} />
                  <YAxis type="category" dataKey="title" stroke="#64748B" width={110} tick={{ fontSize: 11 }} />
                  <Tooltip 
                    contentStyle={{ background: 'rgba(15,23,42,0.95)', border: '1px solid rgba(148,163,184,0.2)', borderRadius: '8px' }}
                    formatter={(value) => [value.toLocaleString(), 'Postings']}
                  />
                  <Bar dataKey="postings" radius={[0, 4, 4, 0]}>
                    {jobShareData.map((entry, index) => (
                      <Cell key={index} fill={entry.color} />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
            </div>
            
            <div className="grid grid-cols-3 gap-3">
              <div className="bg-gradient-to-br from-cyan-500/20 to-cyan-500/5 rounded-xl p-4 border border-cyan-500/30">
                <p className="text-cyan-400 text-xs mb-1">DE Market Share</p>
                <p className="text-2xl font-bold">30.5%</p>
                <p className="text-slate-400 text-xs">of remote data jobs</p>
              </div>
              <div className="bg-gradient-to-br from-indigo-500/20 to-indigo-500/5 rounded-xl p-4 border border-indigo-500/30">
                <p className="text-indigo-400 text-xs mb-1">Total DE Postings</p>
                <p className="text-2xl font-bold">21,261</p>
                <p className="text-slate-400 text-xs">positions analyzed</p>
              </div>
              <div className="bg-gradient-to-br from-purple-500/20 to-purple-500/5 rounded-xl p-4 border border-purple-500/30">
                <p className="text-purple-400 text-xs mb-1">vs Data Scientist</p>
                <p className="text-2xl font-bold">1.46x</p>
                <p className="text-slate-400 text-xs">more DE postings</p>
              </div>
            </div>
          </div>
        )}

        {/* Demand Tab */}
        {activeTab === 'demand' && (
          <div className="space-y-4">
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h2 className="text-lg font-semibold mb-4">Top 10 Most In-Demand Skills</h2>
              <ResponsiveContainer width="100%" height={350}>
                <BarChart data={skillsDemandData} margin={{ left: 0, right: 20 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(148,163,184,0.1)" />
                  <XAxis dataKey="skill" stroke="#64748B" tick={{ fontSize: 11 }} />
                  <YAxis stroke="#64748B" tickFormatter={(v) => `${v}%`} domain={[0, 70]} fontSize={11} />
                  <Tooltip 
                    contentStyle={{ background: 'rgba(15,23,42,0.95)', border: '1px solid rgba(148,163,184,0.2)', borderRadius: '8px' }}
                    formatter={(value) => [`${value}%`, 'Job Share']}
                  />
                  <Bar dataKey="share" radius={[4, 4, 0, 0]}>
                    {skillsDemandData.map((entry, index) => (
                      <Cell key={index} fill={
                        entry.type === 'Programming' ? '#0EA5E9' :
                        entry.type === 'Cloud' ? '#8B5CF6' : '#22C55E'
                      } />
                    ))}
                  </Bar>
                </BarChart>
              </ResponsiveContainer>
              <div className="flex justify-center gap-6 mt-3">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded bg-cyan-500" />
                  <span className="text-slate-400 text-xs">Programming</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded bg-purple-500" />
                  <span className="text-slate-400 text-xs">Cloud</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded bg-green-500" />
                  <span className="text-slate-400 text-xs">Libraries</span>
                </div>
              </div>
            </div>
            
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <p className="text-slate-300 text-sm leading-relaxed">
                <strong className="text-cyan-400">SQL and Python</strong> are essential—appearing in ~60% of postings each. 
                <strong className="text-purple-400"> Cloud platforms</strong> (AWS, Azure) follow at ~35%, while 
                <strong className="text-green-400"> Apache Spark</strong> leads big data frameworks at 30%.
              </p>
            </div>
          </div>
        )}

        {/* Salary Tab */}
        {activeTab === 'salary' && (
          <div className="space-y-4">
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h2 className="text-lg font-semibold mb-4">Top 10 Skills by Median Salary</h2>
              <ResponsiveContainer width="100%" height={350}>
                <ComposedChart data={skillsSalaryData} margin={{ left: 0, right: 20 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(148,163,184,0.1)" />
                  <XAxis dataKey="skill" stroke="#64748B" tick={{ fontSize: 11 }} />
                  <YAxis yAxisId="left" stroke="#64748B" tickFormatter={(v) => `$${(v/1000).toFixed(0)}K`} domain={[130000, 180000]} fontSize={11} />
                  <YAxis yAxisId="right" orientation="right" stroke="#22C55E" tickFormatter={(v) => v.toLocaleString()} fontSize={11} />
                  <Tooltip 
                    contentStyle={{ background: 'rgba(15,23,42,0.95)', border: '1px solid rgba(148,163,184,0.2)', borderRadius: '8px' }}
                    formatter={(value, name) => [
                      name === 'medianSalary' ? `$${value.toLocaleString()}` : value.toLocaleString(),
                      name === 'medianSalary' ? 'Median Salary' : 'Job Count'
                    ]}
                  />
                  <Bar yAxisId="left" dataKey="medianSalary" fill="#6366F1" radius={[4, 4, 0, 0]} />
                  <Line yAxisId="right" type="monotone" dataKey="count" stroke="#22C55E" strokeWidth={2} dot={{ fill: '#22C55E', r: 4 }} />
                </ComposedChart>
              </ResponsiveContainer>
              <div className="flex justify-center gap-6 mt-3">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded bg-indigo-500" />
                  <span className="text-slate-400 text-xs">Median Salary</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full bg-green-500" />
                  <span className="text-slate-400 text-xs">Job Count</span>
                </div>
              </div>
            </div>
            
            <div className="grid grid-cols-3 gap-3">
              <div className="bg-gradient-to-br from-green-500/20 to-green-500/5 rounded-xl p-4 border border-green-500/30">
                <p className="text-green-400 text-xs mb-1">Top: MongoDB</p>
                <p className="text-xl font-bold">$173.5K</p>
                <p className="text-slate-400 text-xs">median salary</p>
              </div>
              <div className="bg-gradient-to-br from-indigo-500/20 to-indigo-500/5 rounded-xl p-4 border border-indigo-500/30">
                <p className="text-indigo-400 text-xs mb-1">Best Balance</p>
                <p className="text-xl font-bold">Kafka</p>
                <p className="text-slate-400 text-xs">1,319 jobs @ $147.5K</p>
              </div>
              <div className="bg-gradient-to-br from-orange-500/20 to-orange-500/5 rounded-xl p-4 border border-orange-500/30">
                <p className="text-orange-400 text-xs mb-1">NoSQL Premium</p>
                <p className="text-xl font-bold">+$26K</p>
                <p className="text-slate-400 text-xs">Mongo vs others</p>
              </div>
            </div>
          </div>
        )}

        {/* Optimal Tab */}
        {activeTab === 'optimal' && (
          <div className="space-y-4">
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h2 className="text-lg font-semibold mb-4">Demand vs Salary Matrix</h2>
              <ResponsiveContainer width="100%" height={350}>
                <ScatterChart margin={{ left: 0, right: 20, bottom: 10 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(148,163,184,0.1)" />
                  <XAxis 
                    type="number" 
                    dataKey="demand" 
                    stroke="#64748B" 
                    tickFormatter={(v) => v.toLocaleString()}
                    fontSize={11}
                    label={{ value: 'Job Demand', position: 'bottom', fill: '#64748B', fontSize: 11, offset: -5 }}
                  />
                  <YAxis 
                    type="number" 
                    dataKey="salary" 
                    stroke="#64748B" 
                    tickFormatter={(v) => `$${(v/1000).toFixed(0)}K`}
                    domain={[128000, 150000]}
                    fontSize={11}
                  />
                  <ZAxis type="number" dataKey="rank" range={[150, 400]} />
                  <Tooltip 
                    contentStyle={{ background: 'rgba(15,23,42,0.95)', border: '1px solid rgba(148,163,184,0.2)', borderRadius: '8px' }}
                    content={({ active, payload }) => {
                      if (active && payload && payload.length) {
                        const d = payload[0].payload;
                        return (
                          <div className="bg-slate-900/95 border border-slate-700 rounded-lg p-3">
                            <p className="font-semibold text-white">{d.skill}</p>
                            <p className="text-cyan-400 text-xs">Rank: #{d.rank}</p>
                            <p className="text-slate-400 text-xs">Demand: {d.demand.toLocaleString()} jobs</p>
                            <p className="text-green-400 text-xs">Salary: ${d.salary.toLocaleString()}</p>
                          </div>
                        );
                      }
                      return null;
                    }}
                  />
                  <Scatter name="Skills" data={optimalSkillsData}>
                    {optimalSkillsData.map((entry, index) => (
                      <Cell key={index} fill={
                        entry.rank <= 3 ? '#22C55E' :
                        entry.rank <= 6 ? '#0EA5E9' : '#8B5CF6'
                      } />
                    ))}
                  </Scatter>
                </ScatterChart>
              </ResponsiveContainer>
              <div className="flex justify-center gap-6 mt-3">
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full bg-green-500" />
                  <span className="text-slate-400 text-xs">Top 3 (Best ROI)</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full bg-cyan-500" />
                  <span className="text-slate-400 text-xs">Rank 4-6</span>
                </div>
                <div className="flex items-center gap-2">
                  <div className="w-3 h-3 rounded-full bg-purple-500" />
                  <span className="text-slate-400 text-xs">Rank 7-10</span>
                </div>
              </div>
            </div>
            
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h3 className="font-semibold mb-3">🏆 Combined Ranking</h3>
              <div className="grid grid-cols-5 gap-2">
                {optimalSkillsData.slice(0, 5).map((skill, i) => (
                  <div key={skill.skill} className={`rounded-lg p-3 text-center ${
                    i === 0 ? 'bg-gradient-to-br from-yellow-500/20 to-yellow-500/5 border border-yellow-500/40' :
                    i === 1 ? 'bg-gradient-to-br from-slate-400/20 to-slate-400/5 border border-slate-400/40' :
                    i === 2 ? 'bg-gradient-to-br from-amber-600/20 to-amber-600/5 border border-amber-600/40' :
                    'bg-slate-800/50 border border-slate-700/50'
                  }`}>
                    <p className="text-lg mb-1">{i === 0 ? '🥇' : i === 1 ? '🥈' : i === 2 ? '🥉' : `#${i+1}`}</p>
                    <p className="font-semibold text-sm">{skill.skill}</p>
                    <p className="text-slate-400 text-xs">${(skill.salary/1000).toFixed(0)}K</p>
                  </div>
                ))}
              </div>
            </div>
          </div>
        )}

        {/* Top Paying Tab */}
        {activeTab === 'top' && (
          <div className="space-y-4">
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h2 className="text-lg font-semibold mb-4">Top Paying Data Engineer Positions</h2>
              <ResponsiveContainer width="100%" height={300}>
                <BarChart data={topPayingJobsData} layout="vertical" margin={{ left: 10, right: 20 }}>
                  <CartesianGrid strokeDasharray="3 3" stroke="rgba(148,163,184,0.1)" />
                  <XAxis type="number" stroke="#64748B" tickFormatter={(v) => `$${v}K`} domain={[200, 350]} fontSize={11} />
                  <YAxis type="category" dataKey="company" stroke="#64748B" width={120} tick={{ fontSize: 11 }} />
                  <Tooltip 
                    contentStyle={{ background: 'rgba(15,23,42,0.95)', border: '1px solid rgba(148,163,184,0.2)', borderRadius: '8px' }}
                    formatter={(value) => [`$${value}K`, 'Annual Salary']}
                  />
                  <Bar dataKey="salary" radius={[0, 4, 4, 0]} fill="url(#salaryGrad)" />
                  <defs>
                    <linearGradient id="salaryGrad" x1="0" y1="0" x2="1" y2="0">
                      <stop offset="0%" stopColor="#22C55E" />
                      <stop offset="100%" stopColor="#0EA5E9" />
                    </linearGradient>
                  </defs>
                </BarChart>
              </ResponsiveContainer>
            </div>
            
            <div className="bg-slate-800/50 rounded-xl p-4 border border-slate-700/50">
              <h3 className="font-semibold mb-3">Skills in $240K+ Positions</h3>
              <div className="flex flex-wrap gap-2">
                {['python', 'spark', 'kafka', 'hadoop', 'scala', 'sql', 'kubernetes', 'databricks', 'aws', 'azure'].map(skill => (
                  <span key={skill} className="bg-gradient-to-r from-cyan-500/20 to-indigo-500/20 border border-cyan-500/30 rounded-full px-3 py-1 text-xs font-medium">
                    {skill}
                  </span>
                ))}
              </div>
              <p className="text-slate-400 text-sm mt-3 leading-relaxed">
                <strong className="text-green-400">Python</strong> appears in 6/8 top positions. 
                The <strong className="text-cyan-400">Apache ecosystem</strong> (Spark, Kafka, Hadoop) dominates, with 
                <strong className="text-purple-400"> Scala</strong> as the preferred secondary language.
              </p>
            </div>
          </div>
        )}
      </div>

      {/* Footer */}
      <div className="text-center mt-8 text-slate-500 text-xs">
        <p>Data Source: Luke Barousse's SQL Course • Analysis: PostgreSQL • Viz: React + Recharts</p>
        <p className="mt-1">© 2024 Data Engineer Job Market Analysis</p>
      </div>
    </div>
  );
}

export default App;
